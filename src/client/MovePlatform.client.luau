local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animation = require(ReplicatedStorage.Shared.Animation.Animation)
local EasingFunctions = require(ReplicatedStorage.Shared.Animation.EasingFunctions)

local MovePlatformEvent = ReplicatedStorage.Shared:FindFirstChildOfClass("RemoteEvent")

function stepBetween(from: Part, to: Part): Animation.Step
	return {
		from = from.Position,
		to = to.Position,
		easingFunctions = { -- TODO: Make it read EasingFunctions for individual axis
			x = EasingFunctions[from:GetAttribute("EasingFunction")],
			y = EasingFunctions[from:GetAttribute("EasingFunction")],
			z = EasingFunctions[from:GetAttribute("EasingFunction")],
		},
		duration = from:GetAttribute("Duration"),
	}
end

game.Workspace.DescendantAdded:Connect(function(animatable)
	if not animatable:HasTag("animatable") then
		return
	end

	local instances = animatable:GetChildren()
	table.sort(instances, function(first, second)
		return first:GetAttribute("Order") < second:GetAttribute("Order")
	end)

	local steps = {}
	for i = 2, #instances do
		local previous = instances[i - 1]
		local current = instances[i]
		table.insert(steps, stepBetween(previous, current))
	end

	MovePlatformEvent.OnClientEvent:Connect(function()
		local animation = Animation.new(steps, animatable)
		animation:AnimateForward()
		task.wait(6)
		animation:AnimateBackward()
		task.wait(6)
	end)

	return
end)
