local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Animation = require(ReplicatedStorage.Animation)

local CYCLE_TAG = "cycle"
local MOVEMENT_TAG = "movement"
local MOVEMENT_TARGET_TAG = "movement_target"
local POINT_ORDER_ATTR = "Order"

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(MOVEMENT_TAG)

for _, movement in ipairs(movements) do
	local pathPoints = movement.Path:GetChildren()
	local sortingCriteria = function(first, second)
		return first:GetAttribute(POINT_ORDER_ATTR) < second:GetAttribute(POINT_ORDER_ATTR)
	end

	table.sort(pathPoints, sortingCriteria)

	local movementTargets = movement.Parent:QueryDescendants("." .. MOVEMENT_TARGET_TAG)
	for _, target in ipairs(movementTargets) do
		local animation = Animation.new(pathPoints, target)
		local fire = movement.Fire :: Instance

		local trigger = if movement:HasTag(CYCLE_TAG) then animation.Cycle else animation.AnimateForward
		if fire:IsA("RemoteEvent") then
			fire.OnClientEvent:Connect(function()
				trigger(animation)
			end)
		elseif fire:IsA("BindableEvent") then
			fire.Event:Connect(function()
				trigger(animation)
			end)
		end
	end
end
