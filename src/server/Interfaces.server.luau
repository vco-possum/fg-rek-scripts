local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Interfaces = require(ReplicatedStorage.Interfaces)
local Tags = require(ReplicatedStorage.Tags)

function selectVisually(button: Interfaces.OptionButton)
	button.BorderSizePixel = 10
end

function deslectVisually(button: Interfaces.OptionButton)
	button.BorderSizePixel = 0
end

function clearVisualSelection(buttons: { Interfaces.OptionButton })
	for _, button in ipairs(buttons) do
		deslectVisually(button)
	end
end

function setUp(interface: Interfaces.Interface)
	local buttons = interface.Options:GetChildren() :: { Interfaces.OptionButton }
	local selected = interface.Selected

	for _, button in ipairs(buttons) do
		button.MouseButton1Click:Connect(function()
			clearVisualSelection(buttons)
			selectVisually(button)
			local pointer = button.ObjectValue
			selected.Value = pointer.Value
		end)
	end
end

local interfaces = CollectionService:GetTagged(Tags.SELECTION_INTERFACE) :: Interfaces.Interface

for _, interface in ipairs(interfaces) do
	setUp(interface)
end
