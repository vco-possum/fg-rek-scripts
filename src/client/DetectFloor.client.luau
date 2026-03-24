local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Tags = require(ReplicatedStorage.Tags)

Players.LocalPlayer.CharacterAdded:Connect(function(character)
	local humanoid = character.HumanoidRootPart

	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }
	local ray = Vector3.new(0, -5, 0)

	local lastPlatformPosition = nil
	RunService.Heartbeat:Connect(function()
		local result = workspace:Raycast(humanoid.CFrame.Position, ray, raycastParams)

		if result and result.Instance:HasTag(Tags.MOVEMENT.TARGET) then
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
