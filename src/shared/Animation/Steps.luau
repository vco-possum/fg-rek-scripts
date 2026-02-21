local EasingFunctions = require(script.Parent.EasingFunctions)

local STEP_DURATION_ATTR = "Duration"
local EASING_FUNCTION_ATTR = "EasingFunction"

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

local module = {}

function module.iterateBackwards(collection: { Step }, idx: number?): number?
	if not idx then
		return #collection - 1, collection[#collection]
	end

	if idx > 0 then
		return idx - 1, collection[idx]
	else
		return nil, collection[1]
	end
end

function module.fromPoints(points: { BasePart }): { Step }
	local steps = {}
	for i = 2, #points do
		local previous = points[i - 1]
		local current = points[i]
		table.insert(steps, module.between(previous, current))
	end

	return steps
end

function module.between(from: Part, to: Part): Step
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

function module.reverse(step: Step): Step
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

return module
