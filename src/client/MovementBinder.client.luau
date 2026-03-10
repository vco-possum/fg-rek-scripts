local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animation = require(ReplicatedStorage.Animation)
local Attributes = require(ReplicatedStorage.Attributes)
local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)

local function sortByOrder(first: PVInstance, second: PVInstance): boolean
	local firstOrder = first:GetAttribute(Attributes.ANIMATION.STEP.ORDER)
	local secondOrder = second:GetAttribute(Attributes.ANIMATION.STEP.ORDER)
	return firstOrder < secondOrder
end

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(Tags.MOVEMENT.ROOT)

for _, movement in ipairs(movements) do
	local pathPoints = movement.Path:GetChildren() :: PVInstance

	table.sort(pathPoints, sortByOrder)

	local movementTargets = Utils.findDescendantsWithTag(movement.Parent, Tags.MOVEMENT.TARGET)
	for _, target: Instance in ipairs(movementTargets) do
		local animation = Animation.new(pathPoints, target)
		local fire = Utils.findFirstTaggedDescendant(movement, Tags.MOVEMENT.TRIGGER) :: Instance

		local animate = if movement:HasTag(Tags.MOVEMENT.CYCLE) then animation.Cycle else animation.AnimateForward
		if fire:IsA("RemoteEvent") then
			fire.OnClientEvent:Connect(function()
				animate(animation)
			end)
		elseif fire:IsA("BindableEvent") then
			fire.Event:Connect(function()
				animate(animation)
			end)
		end
	end
end
