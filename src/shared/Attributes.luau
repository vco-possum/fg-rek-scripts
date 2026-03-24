local Attributes = {
	ANIMATION = {
		EASING_FUNCTION = "EasingFunction",
		STEP = {
			ORDER = "Order",
			DURATION = "Duration",
		},
	},
	WHAC_A_RAT = {
		DIFFICULTY = {
			JUMP_TIME = {
				MIN = "JumpTimeMin",
				MAX = "JumpTimeMax",
			},
			JUMP_HEIGHT = {
				MIN = "JumpHeightMin",
				MAX = "JumpHeightMax",
			},
			INBETWEEN_TIME = {
				MIN = "InbetweenTimeMin",
				MAX = "InbetweenTimeMax",
			},
			REQUIRED_SCORE = "RequiredScore",
		},
	},
}

table.freeze(Attributes)

return Attributes
