local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local DETECTOR_RAY = Vector3.new(0, -4, 0)
local PLATFORM_TAG = "platform"

Players.LocalPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character.HumanoidRootPart

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }

	local lastPlatformPosition = nil
	RunService.Heartbeat:Connect(function()
		local result = workspace:Raycast(humanoid.CFrame.Position, DETECTOR_RAY, raycastParams)

		if result and result.Instance:HasTag(PLATFORM_TAG) then
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
