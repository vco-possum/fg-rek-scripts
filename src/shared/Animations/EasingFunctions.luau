local EasingFunctions = {}

export type EasingFunction = (x: number) -> number

EasingFunctions.Function = {
	inOutQuad = function(x: number): number
		return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
	end,

	inOutLin = function(x: number): number
		return x
	end,

	inExponential = function(x: number): number
		return x == 0 and 0 or math.pow(2, 10 * x - 10)
	end,
	outExponential = function(x: number): number
		return x == 1 and 1 or 1 - math.pow(2, -10 * x)
	end,
	inOutExponential = function(x: number): number
		return x == 0 and 0
			or x == 1 and 1
			or x < 0.5 and math.pow(2, 20 * x - 10) / 2
			or (2 - math.pow(2, -20 * x + 10)) / 2
	end,

	outSine = function(x: number): number
		return math.sin((x * math.pi) / 2)
	end,
	inSine = function(x: number): number
		return 1 - math.cos((x * math.pi) / 2)
	end,
	inOutSine = function(x: number): number
		return -(math.cos(math.pi * x) - 1) / 2
	end,

	inCubic = function(x: number): number
		return math.pow(x, 3)
	end,
	outCubic = function(x: number): number
		return 1 - math.pow(1 - x, 3)
	end,
	inOutCubic = function(x: number): number
		return x < 0.5 and 4 * math.pow(x, 3) or 1 - math.pow(-2 * x + 2, 3) / 2
	end,
} :: { [string]: EasingFunction }

function EasingFunctions.fromString(name: string): EasingFunction
	local func = EasingFunctions.Function[name]

	if not func then
		error(`EasingFunction of name '{name}' doesn't exist`)
	end

	return func
end

function EasingFunctions.inverse(func: EasingFunction)
	return function(x: number)
		return (func(1 - x) * -1) + 1
	end
end

table.freeze(EasingFunctions)

return EasingFunctions
