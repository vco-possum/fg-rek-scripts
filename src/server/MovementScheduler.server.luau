local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local MovePlatformEvent = ReplicatedStorage.Shared:FindFirstChild("MovePlatformEvent")

Players.PlayerAdded:Connect(function(player)
	local animatable = CollectionService:GetTagged("animatable")[1] -- NOTE: indexing returned table as temporary fix
	animatable:SetNetworkOwner(player)

	local points = animatable.Parent:FindFirstChild("Points"):GetChildren()
	table.sort(points, function(first, second)
		return first:GetAttribute("Order") < second:GetAttribute("Order")
	end)

	task.wait(3) -- NOTE: while wait() used as temporary fix
	repeat
		MovePlatformEvent:FireAllClients(points, animatable)
	until not task.wait(20)
end)
