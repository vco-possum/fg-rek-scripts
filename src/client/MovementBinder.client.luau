local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animation = require(ReplicatedStorage.Animation)
local Tags = require(ReplicatedStorage.Tags)
local Util = require(ReplicatedStorage.Util)

local POINT_ORDER_ATTR = "Order"

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(Tags.MOVEMENT)

for _, movement in ipairs(movements) do
	local pathPoints = movement.Path:GetChildren()

	local sortingCriteria = function(first, second)
		return first:GetAttribute(POINT_ORDER_ATTR) < second:GetAttribute(POINT_ORDER_ATTR)
	end
	table.sort(pathPoints, sortingCriteria)

	local movementTargets = Util.findDescendantsWithTag(movement.Parent, Tags.MOVEMENT_TARGET)
	for _, target in ipairs(movementTargets) do
		local animation = Animation.new(pathPoints, target)
		local fire = movement.Fire :: Instance

		local animate = if movement:HasTag(Tags.MOVEMENT_CYCLE) then animation.Cycle else animation.AnimateForward
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
