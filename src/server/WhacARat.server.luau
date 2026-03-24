local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Attributes = require(ReplicatedStorage.Attributes)
local Steps = require(ReplicatedStorage.Animations.Steps)
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

local function jumpOut(rat: WhacARat.Rat, onHit: () -> (), difficulty: WhacARat.Difficulty)
	local ratPosition = rat.CFrame
	local jumpHeight = Vector3.new(0, rand:NextNumber(difficulty.jumpHeight.min, difficulty.jumpHeight.max), 0)
	local jumpTime = rand:NextNumber(difficulty.jumpTime.min, difficulty.jumpTime.max)

	local jump: Steps.SerializedStep = {
		from = ratPosition,
		to = ratPosition + jumpHeight,
		easingFunction = "inOutSine",
		duration = jumpTime,
	}

	local connection = rat.ClickDetector.MouseClick:Once(onHit)
	Utils.withConnection(connection, function()
		rat.JumpOut:FireAllClients(jump)
		task.wait(jumpTime)
	end)
end

local function launch(
	rats: { WhacARat.Rat },
	interface: WhacARat.RatInterface,
	confettiEmitters: { WhacARat.ConfettiEmitter }
)
	local score = interface.Score

	local difficulty = readDifficulty(interface)

	if score.NumberValue.Value == 0 then
		while score.NumberValue.Value < difficulty.requiredScore do -- NOTE: Should we add an exit button
			local inbetweenTime = rand:NextNumber(difficulty.inbetweenTime.min, difficulty.inbetweenTime.max)
			local rat = rats[rand:NextInteger(1, #rats)]

			local onHit = function()
				countHit(interface.Score, difficulty)
			end

			jumpOut(rat, onHit, difficulty)
			task.wait(inbetweenTime)
		end

		resetScore(score)
		for _, emitter in ipairs(confettiEmitters) do
			emitter.EmitEvent:FireAllClients()
		end
	else
		error(`Tried to launch WhackARat when the score was not 0 (instead {score.NumberValue.Value})`)
	end
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

local function setUp(instance: Instance)
	if not instance:HasTag(Tags.WHACK_A_RAT.ROOT) then
		return
	end

	local interface = Utils.findFirstTaggedDescendant(instance, Tags.WHACK_A_RAT.INTERFACE) :: WhacARat.RatInterface
	local ratBox = Utils.findFirstTaggedDescendant(instance, Tags.WHACK_A_RAT.BOX) :: WhacARat.RatBox
	local confettiEmitters =
		Utils.findDescendantsWithTag(instance, Tags.WHACK_A_RAT.CONFETTI_EMITTER) :: { WhacARat.ConfettiEmitter }
	local rats: { WhacARat.Rat } = ratBox.Rats:GetChildren()

	interface.Start.MouseButton1Click:Connect(function()
		launch(rats, interface, confettiEmitters)
	end)
end

local whackARats = CollectionService:GetTagged(Tags.WHACK_A_RAT.ROOT)
for _, whackARat in ipairs(whackARats) do
	setUp(whackARat)
end
