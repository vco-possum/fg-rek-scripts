local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tags = require(ReplicatedStorage.Tags)

function selectVisually(button: TextButton)
	button.BorderSizePixel = 5
end

function deslectVisually(button: TextButton)
	button.BorderSizePixel = 0
end

function clearVisualSelection(buttons: { TextButton })
	for _, button in ipairs(buttons) do
		deslectVisually(button)
	end
end

local interfaces = CollectionService:GetTagged(Tags.SELECTION_INTERFACE)

for _, interface in ipairs(interfaces) do
	local buttons = interface.Options:GetChildren() :: { TextButton }
	local selected = interface.Selected :: ObjectValue

	for _, button in ipairs(buttons) do
		button.MouseButton1Click:Connect(function()
			clearVisualSelection(buttons)
			selectVisually(button)
			local pointer = button.ObjectValue
			selected.Value = pointer.Value
		end)
	end
end
