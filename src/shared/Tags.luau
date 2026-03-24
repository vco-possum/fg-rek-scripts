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
		CYCLE = "movement_cycle", -- NOTE: This might be better set by attr?
		LOOP_FOREVER = "movement_loop_forever",
		TRIGGER = "movement_trigger",
		TARGET = "movement_target",
	},
	SELECTION_INTERFACE = "selection_interface",
	RIDE_SELECTOR = {
		ROOT = "ride_selector",
		TRIGGER = "ride_selector_trigger",
		TEXT_WINDOW = "ride_selector_text_window",
	},
	WHACK_A_RAT = {
		ROOT = "whack_a_rat",
		RAT = "whack_a_rat_rat",
		BOX = "whack_a_rat_box",
		INTERFACE = "whack_a_rat_interface",
		CONFETTI_EMITTER = "whack_a_rat_confetti_emitter",
	},
}

table.freeze(Tags)

return Tags
