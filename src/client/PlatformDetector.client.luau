local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

player.CharacterAdded:Connect(function(character)
	local humanoidRootPart = character.HumanoidRootPart

	local rayPath = Vector3.new(0, -4, 0)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = { character }

	local lastPlatformPosition = nil
	RunService.Heartbeat:Connect(function()
		local result = workspace:Raycast(humanoidRootPart.CFrame.Position, rayPath, raycastParams)

		if result and result.Instance:HasTag("platform") then
			if lastPlatformPosition then
				local displacement = result.Instance.CFrame * lastPlatformPosition:Inverse()
				humanoidRootPart.CFrame = displacement * humanoidRootPart.CFrame
			end

			lastPlatformPosition = result.Instance.CFrame
		else
			lastPlatformPosition = nil
		end
	end)
end)
