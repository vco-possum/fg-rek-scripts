local EasingFunctions = {}

export type EasingFunction = (x: number) -> number

function EasingFunctions.Inverse(func: EasingFunction)
	return function(x: number)
		return (func(1 - x) * -1) + 1
	end
end

function EasingFunctions.InOutQuad(x: number): number
	return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end

function EasingFunctions.InOutLin(x: number): number
	return x
end

function EasingFunctions.InExponential(x: number): number
	return x == 0 and 0 or math.pow(2, 10 * x - 10)
end

function EasingFunctions.OutSine(x: number): number
	return math.sin((x * math.pi) / 2)
end
function EasingFunctions.InSine(x: number): number
	return 1 - math.cos((x * math.pi) / 2)
end
function EasingFunctions.InOutSine(x: number): number
	return -(math.cos(math.pi * x) - 1) / 2
end

function EasingFunctions.InCubic(x: number): number
	return math.pow(x, 3)
end
function EasingFunctions.OutCubic(x: number): number
	return 1 - math.pow(1 - x, 3)
end
function EasingFunctions.InOutCubic(x: number): number
	return x < 0.5 and 4 * math.pow(x, 3) or 1 - math.pow(-2 * x + 2, 3) / 2
end

return EasingFunctions
