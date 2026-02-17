local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animation = require(ReplicatedStorage.Animation.Animation)
local EasingFunctions = require(ReplicatedStorage.Animation.EasingFunctions)

local ANIMATED_TAG = "animated"
local ANIMATION_PATH_NAME = "AnimationPath"
local POINT_ORDER_ATTR = "Order"
local STEP_DURATION_ATTR = "Duration"
local EASING_FUNCTION_ATTR = "EasingFunction"

local MovePlatformEvent = ReplicatedStorage:FindFirstChildOfClass("RemoteEvent")

function stepBetween(from: Part, to: Part): Animation.Step
	return {
		from = from.Position,
		to = to.Position,
		easingFunctions = { -- TODO: Make it read EasingFunctions for individual axis
			x = EasingFunctions[from:GetAttribute(EASING_FUNCTION_ATTR)],
			y = EasingFunctions[from:GetAttribute(EASING_FUNCTION_ATTR)],
			z = EasingFunctions[from:GetAttribute(EASING_FUNCTION_ATTR)],
		},
		duration = from:GetAttribute(STEP_DURATION_ATTR),
	}
end

game.Workspace.DescendantAdded:Connect(function(animated)
	if not animated:HasTag(ANIMATED_TAG) then
		return
	end

	local instances = animated.Parent:FindFirstChild(ANIMATION_PATH_NAME):GetChildren()
	table.sort(instances, function(first, second)
		return first:GetAttribute(POINT_ORDER_ATTR) < second:GetAttribute(POINT_ORDER_ATTR)
	end)

	local steps = {}
	for i = 2, #instances do
		local previous = instances[i - 1]
		local current = instances[i]
		table.insert(steps, stepBetween(previous, current))
	end

	MovePlatformEvent.OnClientEvent:Connect(function()
		local animation = Animation.new(steps, animated)
		animation:AnimateForward()
		task.wait(6)
		animation:AnimateBackward()
		task.wait(6)
	end)

	return
end)
