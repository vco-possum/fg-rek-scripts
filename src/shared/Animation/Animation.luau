export type PointIterator = ({ Part }, number?) -> (number?, Part?)

local Animation = {}
Animation.__index = Animation

function Animation.new(points: { Part }, part: Part)
	local self = setmetatable({}, Animation)
	self.points = points
	self.part = part
	return self
end

function Animation:AnimateForward()
	self:Animate(next)
end

function Animation:AnimateBackward()
	self:Animate(_BackwardsIter)
end

function _BackwardsIter(collection: { Part }, idx: number?): (number?, Part?)
	if not idx then
		return #collection - 1, collection[#collection]
	end

	if idx > 0 then
		return idx - 1, collection[idx]
	else
		return nil, collection[1]
	end
end

function Animation:Animate(iter: PointIterator, initIdx: number?)
	local nextIdx, point = iter(self.points, initIdx)
	if nextIdx == nil then
		return
	end

	self.part:FindFirstChild("PlatformAlignPosition").Position = point.CFrame.Position
	task.wait(2)
	self:Animate(iter, nextIdx)
end

function Animation:_TerminateConnection()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

return Animation
