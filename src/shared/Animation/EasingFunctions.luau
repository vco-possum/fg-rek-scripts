local EasingFunctions = {}

export type EasingFunction = (x: number) -> number

function EasingFunctions.inverse(func: EasingFunction)
	return function(x: number)
		return (func(1 - x) * -1) + 1
	end
end

function EasingFunctions.inOutQuad(x: number): number
	return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end

function EasingFunctions.inOutLin(x: number): number
	return x
end

function EasingFunctions.inExponential(x: number): number
	return x == 0 and 0 or math.pow(2, 10 * x - 10)
end
function EasingFunctions.outExponential(x: number): number
	return x == 1 and 1 or 1 - math.pow(2, -10 * x)
end
function EasingFunctions.inOutExponential(x: number): number
	return x == 0 and 0
		or x == 1 and 1
		or x < 0.5 and math.pow(2, 20 * x - 10) / 2
		or (2 - math.pow(2, -20 * x + 10)) / 2
end

function EasingFunctions.outSine(x: number): number
	return math.sin((x * math.pi) / 2)
end
function EasingFunctions.inSine(x: number): number
	return 1 - math.cos((x * math.pi) / 2)
end
function EasingFunctions.inOutSine(x: number): number
	return -(math.cos(math.pi * x) - 1) / 2
end

function EasingFunctions.inCubic(x: number): number
	return math.pow(x, 3)
end
function EasingFunctions.outCubic(x: number): number
	return 1 - math.pow(1 - x, 3)
end
function EasingFunctions.inOutCubic(x: number): number
	return x < 0.5 and 4 * math.pow(x, 3) or 1 - math.pow(-2 * x + 2, 3) / 2
end

table.freeze(EasingFunctions)

return EasingFunctions
