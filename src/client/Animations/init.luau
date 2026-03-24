local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Steps = require(ReplicatedStorage.Animations.Steps)

export type Animation = {
	Steps: { Steps.Step },
	Part: PVInstance,
	Duration: number,
	_Connection: RBXScriptConnection,
	new: (points: { Steps.Step }, part: Part) -> Animation,
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

	local previous: Steps.StepIter = function(steps, idx)
		local nextIdx, step = Steps.iterateBackwards(steps, idx)
		return nextIdx, Steps.reverse(step)
	end
	self:_Animate(previous)
end

function Animation:Cycle()
	self:_TerminateConnection()

	self:AnimateForward()
	task.wait(self.Duration)
	self:AnimateBackward()
	task.wait(self.Duration)
end

function Animation:_Animate(iter: Steps.StepIter, initIdx: number?)
	local nextIdx, step = iter(self.Steps, initIdx)
	if nextIdx == nil then
		return
	end

	local progress = 0 -- normalized progress, ranges from 0 to 1
	self._Connection = RunService.PreSimulation:Connect(function(deltaTime)
		progress = math.clamp(progress + deltaTime / step.duration, 0, 1)

		self.Part.CFrame = step.from:Lerp(step.to, step.easingFunction(progress))

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

table.freeze(Animation)

local Constructor = {}
function Constructor.new(steps: { Steps.Step }, part: PVInstance): Animation
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

return Constructor
