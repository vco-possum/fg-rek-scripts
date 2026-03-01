local module = {}

function module.connectWithMutex(event: RBXScriptSignal, func: (...any) -> ...any): ...any
	local lock = false

	local funcWithMutex = function()
		if not lock then
			lock = true
			func()
			lock = false
		end
	end

	return event:Connect(funcWithMutex)
end

return module
