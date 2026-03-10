local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Attributes = require(ReplicatedStorage.Attributes)
local EasingFunctions = require(script.Parent.EasingFunctions)

export type Step = {
	from: Vector3,
	to: Vector3,
	easingFunctions: {
		x: EasingFunctions.EasingFunction,
		y: EasingFunctions.EasingFunction,
		z: EasingFunctions.EasingFunction,
	},
	duration: number,
}

export type StepIter = ({ Step }, number?) -> (number?, Step?)

local Steps = {}

function Steps.iterateBackwards(collection: { Step }, idx: number?): number?
	if not idx then
		return #collection - 1, collection[#collection]
	end

	if idx > 0 then
		return idx - 1, collection[idx]
	else
		return nil, collection[1]
	end
end

function Steps.fromPoints(points: { PVInstance }): { Step }
	local steps = {}
	for i = 2, #points do
		local previous = points[i - 1]
		local current = points[i]
		table.insert(steps, Steps.between(previous, current))
	end

	return steps
end

function Steps.between(from: Part, to: Part): Step
	return {
		from = from.Position,
		to = to.Position,
		easingFunctions = { -- TODO: Make it read EasingFunctions for individual axis
			x = EasingFunctions[from:GetAttribute(Attributes.ANIMATION.EASING_FUNCTION)],
			y = EasingFunctions[from:GetAttribute(Attributes.ANIMATION.EASING_FUNCTION)],
			z = EasingFunctions[from:GetAttribute(Attributes.ANIMATION.EASING_FUNCTION)],
		},
		duration = from:GetAttribute(Attributes.ANIMATION.STEP.DURATION),
	}
end

function Steps.reverse(step: Step): Step
	return {
		from = step.to,
		to = step.from,
		easingFunctions = {
			x = EasingFunctions.inverse(step.easingFunctions.x),
			y = EasingFunctions.inverse(step.easingFunctions.y),
			z = EasingFunctions.inverse(step.easingFunctions.z),
		},
		duration = step.duration,
	}
end

function Steps.totalDuration(steps: { Step }): number
	local duration = 0
	for _, step in ipairs(steps) do
		duration += step.duration
	end

	return duration
end

table.freeze(Steps)

return Steps
