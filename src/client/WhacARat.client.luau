local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Animations = require(StarterPlayer.StarterPlayerScripts.Animations)
local Steps = require(ReplicatedStorage.Animations.Steps)
local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)
local WhacARat = require(ReplicatedStorage.WhacARat)

workspace.PersistentLoaded:Wait() -- NOTE: Could use CollectionService.TagAdded instead, but only one WhacARat could exist then

local function jumpOut(rat: WhacARat.Rat, steps: { Steps.Step })
	local connection = rat.ClickDetector.MouseClick:Once(function()
		rat.JumpOut:FireServer()
	end)

	Utils.withConnection(connection, function()
		local animation = Animations.new(steps, rat)
		animation:Cycle()
		task.wait(animation.Duration * 2)
	end)
end

local function onJump(rat: WhacARat.Rat, serializedSteps: { Steps.SerializedStep })
	local steps = {}
	for _, step in ipairs(serializedSteps) do
		table.insert(steps, Steps.deserialize(step))
	end

	jumpOut(rat, steps)
end

local function setUpRat(rat: WhacARat.Rat)
	rat.JumpOut.OnClientEvent:Connect(onJump)
end

local rats: { WhacARat.Rat } = CollectionService:GetTagged(Tags.WHACK_A_RAT.RAT)
for _, rat in ipairs(rats) do
	setUpRat(rat)
end

local function setUpConfettiEmitter(confettiEmitter: WhacARat.ConfettiEmitter)
	confettiEmitter.EmitEvent.OnClientEvent:Connect(function(count: number)
		confettiEmitter:Emit(count)
	end)
end

local confettiEmitters: { WhacARat.ConfettiEmitter } = CollectionService:GetTagged(Tags.WHACK_A_RAT.CONFETTI_EMITTER)
for _, emitter in ipairs(confettiEmitters) do
	setUpConfettiEmitter(emitter)
end

local function setUpSeat(seat: Seat & { Unseat: RemoteFunction })
	local function unseat()
		seat.Disabled = true
		seat.Unseat:InvokeServer()
	end

	seat.Unseat.OnClientInvoke = unseat
end

local seats = CollectionService:GetTagged(Tags.WHACK_A_RAT.SEAT) :: { Seat & { Unseat: RemoteFunction } }
for _, seat in ipairs(seats) do
	setUpSeat(seat)
end
