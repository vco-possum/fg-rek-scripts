local EasingFunctions = {}

function EasingFunctions.InOutQuad(x: number): number
	return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2
end
function EasingFunctions.InOutLin(x: number): number
	return x
end
function EasingFunctions.InExponential(x: number): number
	return x == 0 and 0 or math.pow(2, 10 * x - 10)
end

return EasingFunctions
