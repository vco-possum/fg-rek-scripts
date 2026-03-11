local Tags = {
	ANIMATED_BUTTON = {
		ROOT = "animated_button",
		CLICK_DETECTOR = "animated_button_click_detector",
		ANIMATION_TRIGGER = "animated_button_animation_trigger",
	},
	MONEY = {
		SUBSTRACT = "money_substract",
		ADD = "money_add",
	},
	MOVEMENT = {
		ROOT = "movement",
		CYCLE = "movement_cycle",
		LOOP = "movement_loop",
		TRIGGER = "movement_trigger",
		TARGET = "movement_target",
	},
	SELECTION_INTERFACE = "selection_interface",
	RIDE_SELECTOR = {
		ROOT = "ride_selector",
		TRIGGER = "ride_selector_trigger",
		TEXT_WINDOW = "ride_selector_text_window",
	},
}

table.freeze(Tags)

return Tags
