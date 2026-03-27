local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Attributes = require(ReplicatedStorage.Attributes)
local Steps = require(ReplicatedStorage.Animations.Steps)
local Constants = require(ReplicatedStorage.Constants)
local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)
local WhacARat = require(ReplicatedStorage.WhacARat)

local rand = Random.new()

local function countHit(score: WhacARat.Score, difficulty: WhacARat.Difficulty)
	local value = score.NumberValue.Value
	score.NumberValue.Value = value + 1
	score.Text = `{score.NumberValue.Value}/{difficulty.requiredScore}`
end

local function resetScore(score: WhacARat.Score)
	score.NumberValue.Value = 0
	score.Text = tostring(score.NumberValue.Value)
end

function readDifficulty(ratInterface: WhacARat.RatInterface): WhacARat.Difficulty
	local difficulty = ratInterface.Selected.Value

	return {
		jumpTime = {
			min = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.JUMP_TIME.MIN),
			max = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.JUMP_TIME.MAX),
		},
		jumpHeight = {
			min = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.JUMP_HEIGHT.MIN),
			max = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.JUMP_HEIGHT.MAX),
		},
		inbetweenTime = {
			min = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.INBETWEEN_TIME.MIN),
			max = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.INBETWEEN_TIME.MAX),
		},
		requiredScore = difficulty:GetAttribute(Attributes.WHAC_A_RAT.DIFFICULTY.REQUIRED_SCORE),
	}
end

function afterUnseating(seat: Seat & { Unseat: RemoteFunction }, callback: (player: Player) -> ())
	local occupant = seat.Occupant
	if occupant then
		local player = Players:GetPlayerFromCharacter(occupant.Parent)

		seat.Unseat.OnServerInvoke = function()
			seat.Disabled = true
			callback(player)
			seat.Disabled = false
		end

		seat.Unseat:InvokeClient(player)
	end
end

function teleport(player: Player, destination: CFrame)
	local character = player.Character
	local humanoid = character.Humanoid :: Humanoid
	local rootPart = humanoid.RootPart
	rootPart:PivotTo(destination)
end

function jumpOut(rats: { WhacARat.Rat }, score: WhacARat.Score, difficulty: WhacARat.Difficulty)
	local inbetweenTime = rand:NextNumber(difficulty.inbetweenTime.min, difficulty.inbetweenTime.max)
	local rat = rats[rand:NextInteger(1, #rats)]

	local ratPosition = rat.CFrame
	local jumpHeight = Vector3.new(0, rand:NextNumber(difficulty.jumpHeight.min, difficulty.jumpHeight.max), 0)
	local jumpTime = rand:NextNumber(difficulty.jumpTime.min, difficulty.jumpTime.max)

	local jump: Steps.SerializedStep = {
		from = ratPosition,
		to = ratPosition + jumpHeight,
		easingFunction = "inOutSine",
		duration = jumpTime,
	}

	local function onJumpOut()
		countHit(score, difficulty)
	end

	local jumpOutConnection = rat.JumpOut.OnServerEvent:Once(onJumpOut)
	Utils.withConnection(jumpOutConnection, function()
		rat.JumpOut:FireAllClients(rat, { jump })
		task.wait(jumpTime + inbetweenTime) -- NOTE: Add some slack time im case message comes late
	end)
end

local function launch(
	rats: { WhacARat.Rat },
	interface: WhacARat.RatInterface,
	confettiEmitters: { WhacARat.ConfettiEmitter },
	seat: Seat & { Unseat: RemoteFunction }
)
	local score = interface.Score
	local difficulty = readDifficulty(interface)

	if score.NumberValue.Value == 0 then
		while score.NumberValue.Value < difficulty.requiredScore do -- NOTE: Should we add an exit button?
			jumpOut(rats, score, difficulty)
		end

		resetScore(score)
		for _, emitter in ipairs(confettiEmitters) do
			emitter.EmitEvent:FireAllClients()
		end
		task.wait(confettiEmitters[1].Lifetime.Max) -- HACK: Either define constant, or calc max from all

		afterUnseating(seat, function(player: Player)
			teleport(player, Constants.SAWN_POSITION)
		end)
	else
		error(`Tried to launch WhackARat when the score was not 0 (instead {score.NumberValue.Value})`)
	end
end

local function setUp(instance: Instance)
	if not instance:HasTag(Tags.WHACK_A_RAT.ROOT) then
		return
	end

	local interface = Utils.findFirstTaggedDescendant(instance, Tags.WHACK_A_RAT.INTERFACE) :: WhacARat.RatInterface
	local ratBox = Utils.findFirstTaggedDescendant(instance, Tags.WHACK_A_RAT.BOX) :: WhacARat.RatBox
	local confettiEmitters =
		Utils.findDescendantsWithTag(instance, Tags.WHACK_A_RAT.CONFETTI_EMITTER) :: { WhacARat.ConfettiEmitter }
	local seat = Utils.findFirstTaggedDescendant(instance, Tags.WHACK_A_RAT.SEAT) :: Seat
	local rats: { WhacARat.Rat } = ratBox.Rats:GetChildren()

	Utils.connectWithMutex(interface.Start.MouseButton1Click, function()
		launch(rats, interface, confettiEmitters, seat)
	end)
end

local whackARats = CollectionService:GetTagged(Tags.WHACK_A_RAT.ROOT)
for _, whackARat in ipairs(whackARats) do
	setUp(whackARat)
end
