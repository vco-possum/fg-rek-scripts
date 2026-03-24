local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")

local Animations = require(StarterPlayer.StarterPlayerScripts.Animations)
local Steps = require(ReplicatedStorage.Animations.Steps)
local Tags = require(ReplicatedStorage.Tags)
local WhacARat = require(ReplicatedStorage.WhacARat)

workspace.PersistentLoaded:Wait() -- NOTE: Could use CollectionService.TagAdded instead, but only one WhacARat could exist then

local function setUpRat(rat: WhacARat.Rat)
	rat.JumpOut.OnClientEvent:Connect(function(serializedStep: Steps.SerializedStep)
		local step = Steps.deserialize(serializedStep)
		Animations.new({ step }, rat):Cycle()
	end)
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
