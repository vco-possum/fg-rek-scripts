local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utils = require(ReplicatedStorage.Util)

local RIDE_SELECTOR_TAG = "ride_selector"
local RIDE_SELECTOR_INTERFACE_TAG = "ride_selector_interface"
local RIDE_SELECTOR_TRIGGER_TAG = "ride_selector_trigger"

local selectors = CollectionService:GetTagged(RIDE_SELECTOR_TAG)

for _, selector: Model in ipairs(selectors) do
	local interface = selector:QueryDescendants("." .. RIDE_SELECTOR_INTERFACE_TAG)[1] :: SurfaceGui
	local trigger = selector:QueryDescendants("." .. RIDE_SELECTOR_TRIGGER_TAG)[1] :: ClickDetector
	local selected = interface.Selected :: ObjectValue

	Utils.connectWithMutex(trigger.MouseClick, function()
		local textField = interface.TextField :: TextLabel

		if selected.Value == nil then
			local previousText = textField.Text

			textField.Text = "SELECT RIDE!!! >:(("
			task.wait(1)

			textField.Text = previousText
		else
			local previousText = textField.Text

			local messages = {
				"Starting in...",
				"3",
				"2",
				"1",
			}
			for _, message in ipairs(messages) do
				textField.Text = message
				task.wait(1)
			end

			local selectorParent = selector.Parent
			selector.Parent = nil

			local movementEvent = selected.Value.Fire :: RemoteEvent
			movementEvent:FireAllClients()

			task.wait(1)

			textField.Text = previousText
			selector.Parent = selectorParent
		end
	end)
end
