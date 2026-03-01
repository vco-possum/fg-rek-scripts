local module = {}

export type EasingFunction = (x: number) -> number

function module.inverse(func: EasingFunction)
	return function(x: number)
		return (func(1 - x) * -1) + 1
	end
end

function module.inOutQuad(x: number): number
	return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end

function module.inOutLin(x: number): number
	return x
end

function module.inExponential(x: number): number
	return x == 0 and 0 or math.pow(2, 10 * x - 10)
end
function module.outExponential(x: number): number
	return x == 1 and 1 or 1 - math.pow(2, -10 * x)
end
function module.inOutExponential(x: number): number
	return x == 0 and 0
		or x == 1 and 1
		or x < 0.5 and math.pow(2, 20 * x - 10) / 2
		or (2 - math.pow(2, -20 * x + 10)) / 2
end

function module.outSine(x: number): number
	return math.sin((x * math.pi) / 2)
end
function module.inSine(x: number): number
	return 1 - math.cos((x * math.pi) / 2)
end
function module.inOutSine(x: number): number
	return -(math.cos(math.pi * x) - 1) / 2
end

function module.inCubic(x: number): number
	return math.pow(x, 3)
end
function module.outCubic(x: number): number
	return 1 - math.pow(1 - x, 3)
end
function module.inOutCubic(x: number): number
	return x < 0.5 and 4 * math.pow(x, 3) or 1 - math.pow(-2 * x + 2, 3) / 2
end

return module
