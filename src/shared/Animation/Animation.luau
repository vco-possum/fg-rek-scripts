local RunService = game:GetService("RunService")
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
export type StepIterator = ({ Step }, number?) -> (number?, Step?)

local Animation = {}
Animation.__index = Animation

function Animation.new(steps: { Step }, part: Part)
	local self = setmetatable({}, Animation)
	self.steps = steps
	self.part = part
	self.connection = nil
	return self
end

function Animation:AnimateForward()
	self:Animate(next)
end

function Animation:AnimateBackward()
	self:Animate(_ReversingBackwardsIter)
end

function _ReversingBackwardsIter(collection: { Step }, idx: number?): (number?, Step?)
	local nextIdx, step = _BackwardsIter(collection, idx)
	return nextIdx, _Reverse(step)
end

function _BackwardsIter(collection: { Step }, idx: number?): (number?, Step?)
	if not idx then
		return #collection - 1, collection[#collection]
	end

	if idx > 0 then
		return idx - 1, collection[idx]
	else
		return nil, collection[1]
	end
end

function _Reverse(step: Step): Step
	return {
		from = step.to,
		to = step.from,
		easingFunctions = {
			x = EasingFunctions.Inverse(step.easingFunctions.x),
			y = EasingFunctions.Inverse(step.easingFunctions.y),
			z = EasingFunctions.Inverse(step.easingFunctions.z),
		},
		duration = step.duration,
	}
end

function Animation:Animate(iter: StepIterator, initIdx: number?)
	local nextIdx, step = iter(self.steps, initIdx)
	if nextIdx == nil then
		return
	end

	local progress = 0 -- normalized progress, ranges from 0 to 1
	self.connection = RunService.PreSimulation:Connect(function(deltaTime)
		progress = math.clamp(progress + deltaTime / step.duration, 0, 1)

		local easing = Vector3.new(
			step.easingFunctions.x(progress),
			step.easingFunctions.y(progress),
			step.easingFunctions.z(progress)
		)
		local displacement = (step.to - step.from) * easing
		local newPosition = step.from + displacement

		self.part.CFrame = CFrame.new(newPosition)
		if progress >= 1 then
			self:_TerminateConnection()
			self:Animate(iter, nextIdx)
		end
	end)
end

function Animation:_TerminateConnection()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return Animation
