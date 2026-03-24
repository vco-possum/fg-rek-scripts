local Utils = {}

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

function Utils.findDescendantsWithTag(instance: Instance, tag: string): { Instance }
	return instance:QueryDescendants("." .. tag)
end

function Utils.findFirstTaggedDescendant(instance: Instance, tag: string): Instance
	return Utils.findDescendantsWithTag(instance, tag)[1] -- NOTE: Is [] selection the right choice?
end

function Utils.withConnection(connection: RBXScriptConnection, func: () -> ())
	func()
	connection:disconnect()
end

-- Saves property before executing function and restores it after executing it
function Utils.withRestoreProperty(instance: Instance, property: string, func: () -> ())
	local previous = instance[property]
	func()
	instance[property] = previous
end

table.freeze(Utils)

return Utils
