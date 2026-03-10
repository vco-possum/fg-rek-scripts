local Tags = {
	BUTTON_ANIMATION = "button_animation",
	MOVEMENT = {
		ROOT = "movement",
		CYCLE = "movement_cycle",
		LOOP = "movement_loop",
		TRIGGER = "movement_trigger",
		TARGET = "movement_target",
	},
	RIDE_SELECTOR = {
		ROOT = "ride_selector",
		INTERFACE = "ride_selector_interface",
		TRIGGER = "ride_selector_trigger",
	},
	MONEY = {
		SUBSTRACT = "money_substract",
		ADD = "money_add",
	},
}

table.freeze(Tags)

return Tags
