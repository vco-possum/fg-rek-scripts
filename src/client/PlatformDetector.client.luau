local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Tags = require(ReplicatedStorage.Tags)

local DETECTOR_RAY = Vector3.new(0, -5, 0)

Players.LocalPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character.HumanoidRootPart

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }

	local lastPlatformPosition = nil
	RunService.Heartbeat:Connect(function()
		local result = workspace:Raycast(humanoid.CFrame.Position, DETECTOR_RAY, raycastParams)

		if result and result.Instance:HasTag(Tags.MOVING_PLATFORM) then
			if lastPlatformPosition then
				local displacement = result.Instance.CFrame * lastPlatformPosition:Inverse()
				humanoid.CFrame = displacement * humanoid.CFrame
			end

			lastPlatformPosition = result.Instance.CFrame
		else
			lastPlatformPosition = nil
		end
	end)
end)
