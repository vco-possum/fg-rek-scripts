local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Animation = require(ReplicatedStorage.Shared.Animation.Animation)

local MovePlatformEvent = ReplicatedStorage.Shared:FindFirstChildOfClass("RemoteEvent")

MovePlatformEvent.OnClientEvent:Connect(function(points, animatable)
	local animation = Animation.new(points, animatable)
	animation:AnimateForward()
	animation:AnimateBackward()
end)
