local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Interfaces = require(ReplicatedStorage.Interfaces)

export type RatBox = BasePart & {
	Rats: Folder,
}

export type RatInterface = Interfaces.Interface & {
	MainWindow: TextLabel,
	Score: Score,
	Start: TextButton,
}

export type Rat = MeshPart & {
	JumpOut: RemoteEvent,
	ClickDetector: ClickDetector,
}

export type Score = TextLabel & { NumberValue: NumberValue }

export type ConfettiEmitter = ParticleEmitter & {
	EmitEvent: RemoteEvent,
}

export type Difficulty = {
	jumpTime: {
		min: number,
		max: number,
	},
	jumpHeight: {
		min: number,
		max: number,
	},
	inbetweenTime: {
		min: number,
		max: number,
	},
	requiredScore: number,
}

return nil
