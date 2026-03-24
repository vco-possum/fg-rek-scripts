local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Attributes = require(ReplicatedStorage.Attributes)
local EasingFunctions = require(ReplicatedStorage.Animations.EasingFunctions)

export type Step = {
	from: CFrame,
	to: CFrame,
	easingFunction: EasingFunctions.EasingFunction,
	duration: number,
}

export type SerializedStep = {
	from: CFrame,
	to: CFrame,
	easingFunction: string,
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

function Steps.between(from: PVInstance, to: PVInstance): Step
	local easingFunction = from:GetAttribute(Attributes.ANIMATION.EASING_FUNCTION) :: string
	return {
		from = from:GetPivot(),
		to = to:GetPivot(),
		easingFunction = EasingFunctions.fromString(easingFunction),
		duration = from:GetAttribute(Attributes.ANIMATION.STEP.DURATION),
	}
end

function Steps.deserialize(serialized: SerializedStep): Step
	return {
		from = serialized.from,
		to = serialized.to,
		easingFunction = EasingFunctions.fromString(serialized.easingFunction),
		duration = serialized.duration,
	}
end

function Steps.reverse(step: Step): Step
	return {
		from = step.to,
		to = step.from,
		easingFunction = step.easingFunction,
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
