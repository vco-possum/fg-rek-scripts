local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Animation = require(ReplicatedStorage.Animation)

local MOVEMENT_TAG = "movement"
local TAG_SELECTOR = "."
local MOVEMENT_TARGET_TAG = "movement_target"
local POINT_ORDER_ATTR = "Order"

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(MOVEMENT_TAG)

for _, movement in ipairs(movements) do
	local pathPoints = movement.Path:GetChildren()
	table.sort(pathPoints, function(first, second)
		return first:GetAttribute(POINT_ORDER_ATTR) < second:GetAttribute(POINT_ORDER_ATTR)
	end)

	local moved = movement.Parent:QueryDescendants(TAG_SELECTOR .. MOVEMENT_TARGET_TAG)
	for _, instance in ipairs(moved) do
		movement.Fire.OnClientEvent:Connect(function()
			local animation = Animation.new(pathPoints, instance)
			animation:Cycle()
		end)
	end
end
