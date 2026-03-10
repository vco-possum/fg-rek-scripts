local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Constants)

Players.PlayerAdded:Connect(function(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = Constants.LEADERSTATS.NAME
	leaderstats.Parent = player

	local money = Instance.new("IntValue")
	money.Name = Constants.MONEY.NAME
	money.Value = Constants.MONEY.DEFAULT_VALUE
	money.Parent = leaderstats
end)
