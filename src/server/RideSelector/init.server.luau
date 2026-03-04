local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Util)

local selectors = CollectionService:GetTagged(Tags.RIDE_SELECTOR)

function setUp(selector: Model)
	local interface = Utils.findFirstDescendantWithTag(selector, Tags.RIDE_SELECTOR_INTERFACE) :: SurfaceGui
	local trigger = Utils.findFirstDescendantWithTag(selector, Tags.RIDE_SELECTOR_TRIGGER) :: ClickDetector
	local selected = interface.Selected :: ObjectValue

	Utils.connectWithMutex(trigger.MouseClick, function()
		local textField = interface.TextField :: TextLabel

		if selected.Value == nil then
			Utils.withRestorePrevious(textField, "Text", function()
				textField.Text = "SELECT RIDE!!! >:(("
				task.wait(1)
			end)
		else
			local messages = {
				"Starting in...",
				"3",
				"2",
				"1",
			}
			Utils.withRestorePrevious(textField, "Text", function()
				for _, message in ipairs(messages) do
					textField.Text = message
					task.wait(1)
				end
			end)

			Utils.withRestorePrevious(selector, "Parent", function()
				selector.Parent = nil

				local movementEvent = selected.Value.Fire :: RemoteEvent
				movementEvent:FireAllClients()

				task.wait(1)
			end)
		end
	end)
end

for _, selector: Model in ipairs(selectors) do
	setUp(selector)
end
