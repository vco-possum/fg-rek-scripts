local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Constants)

local Money = {}

function Money.add(player, amount: number)
	local money = player[Constants.LEADERSTATS.NAME][Constants.MONEY.NAME] :: IntValue
	money.Value += amount
end

function Money.substract(player, amount: number)
	local money = player[Constants.LEADERSTATS.NAME][Constants.MONEY.NAME] :: IntValue
	if amount > money.Value then
		error(`Player {player.Name} doesn't have enough money to substract ({amount} > {money.Value})`)
	else
		money.Value -= amount
	end
end

table.freeze(Money)

return Money
