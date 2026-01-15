local Workspace = game:GetService("Workspace")
local Animation = require(script.Parent.Animation)
local EasingFunctions = require(script.Parent.Utils.EasingFunctions)

local MovingBlock = Workspace:WaitForChild("MovingBlock")
local initPosition = MovingBlock.CFrame
local destPosition = CFrame.new(0, 50, 50)

local easing = {
	x = EasingFunctions.InOutQuad,
	y = EasingFunctions.InExponential,
	z = EasingFunctions.InOutLin,
}
local forwardAnimation = Animation.new(MovingBlock, initPosition, destPosition, easing, 2)
local backwardAnimation = Animation.new(MovingBlock, destPosition, initPosition, easing, 2)

while true do
	forwardAnimation:Trigger()
	task.wait(2)
	backwardAnimation:Trigger()
	task.wait(2)
end
