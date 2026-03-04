local module = {}

local TAG_SELECTOR = "."

function module.findDescendantsWithTag(instance: Instance, tag: string): { Instance }
	return instance:QueryDescendants(TAG_SELECTOR .. tag)
end

function module.findFirstDescendantWithTag(instance: Instance, tag: string): Instance
	return module.findDescendantsWithTag(instance, tag)[1] -- TODO: Is [] selection the right choice?
end

-- Saves property before executing function and restores it after executing it
function module.withRestorePrevious(instance: Instance, property: string, func: () -> ())
	local previous = instance[property]
	func()
	instance[property] = previous
end

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
