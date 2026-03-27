local Constants = {
	SAWN_POSITION = CFrame.new(Vector3.new(0, 3, 0)),
	LEADERSTATS = {
		NAME = "leaderstats",
	},
	MONEY = {
		NAME = "Money",
		DEFAULT_VALUE = 100,
	},
	RIDE_SELECTOR = {
		MESSAGE_DEBOUNCE = 1,
		PAYMENT_AMOUNT = 50,
		DISSAPEAR_DEBOUNCE = 5,
	},
}

table.freeze(Constants)

return Constants
