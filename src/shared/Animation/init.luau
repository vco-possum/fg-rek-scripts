local RunService = game:GetService("RunService")
local Steps = require(script.Steps)

export type Animation = {
	Steps: { Steps.Step },
	Part: Instance,
	Duration: number,
	_Connection: RBXScriptConnection,
	AnimateForward: (self: Animation) -> (),
	AnimateBackward: (self: Animation) -> (),
	Cycle: (self: Animation) -> (),
	_Animate: (self: Animation, iter: Steps.StepIter, initIdx: number?) -> (),
	_TerminateConnection: (self: Animation) -> (),
}

local Animation = {} :: Animation
Animation.__index = Animation

function Animation:AnimateForward()
	self:_TerminateConnection()

	self:_Animate(next)
end

function Animation:AnimateBackward()
	self:_TerminateConnection()

	local backwards: Steps.StepIter = function(steps, idx)
		local nextIdx, step = Steps.iterateBackwards(steps, idx)
		return nextIdx, Steps.reverse(step)
	end
	self:_Animate(backwards)
end

function Animation:Cycle()
	self:_TerminateConnection()

	self:AnimateForward()
	task.wait(self.Duration)
	self:AnimateBackward()
end

function Animation:_Animate(iter: Steps.StepIter, initIdx: number?)
	local nextIdx, step = iter(self.Steps, initIdx)
	if nextIdx == nil then
		return
	end

	local progress = 0 -- normalized progress, ranges from 0 to 1
	self._Connection = RunService.PreSimulation:Connect(function(deltaTime)
		progress = math.clamp(progress + deltaTime / step.duration, 0, 1)

		local easing = Vector3.new(
			step.easingFunctions.x(progress),
			step.easingFunctions.y(progress),
			step.easingFunctions.z(progress)
		)
		local displacement = (step.to - step.from) * easing
		local newPosition = step.from + displacement
		self.Part.CFrame = CFrame.new(newPosition)

		if progress >= 1 then
			self:_TerminateConnection()
			self:_Animate(iter, nextIdx)
		end
	end)
end

function Animation:_TerminateConnection()
	if self._Connection then
		self._Connection:Disconnect()
		self._Connection = nil
	end
end

local module = {}

function module.new(points: { BasePart }, part: Part): Animation
	local steps = Steps.fromPoints(points)

	local duration = 0
	for _, step in ipairs(steps) do
		duration += step.duration
	end

	local self = setmetatable({}, Animation)
	self.Steps = steps
	self.Part = part
	self._Connection = nil
	self.Lock = false
	self.Duration = duration

	return self :: Animation
end

return module
