local Utils = {}

function Utils.findDescendantsWithTag(instance: Instance, tag: string): { Instance }
	return instance:QueryDescendants("." .. tag)
end

function Utils.findFirstTaggedDescendant(instance: Instance, tag: string): Instance
	return Utils.findDescendantsWithTag(instance, tag)[1] -- TODO: Is [] selection the right choice?
end

-- Saves property before executing function and restores it after executing it
function Utils.withRestorePrevious(instance: Instance, property: string, func: () -> ())
	local previous = instance[property]
	func()
	instance[property] = previous
end

function Utils.connectWithMutex(event: RBXScriptSignal, func: (...any) -> ...any): ...any
	local lock = false

	local funcWithMutex = function(...)
		if not lock then
			lock = true
			func(...)
			lock = false
		end
	end

	return event:Connect(funcWithMutex)
end

table.freeze(Utils)

return Utils
