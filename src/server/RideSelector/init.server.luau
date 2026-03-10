local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Constants)
local Money = require(ServerScriptService.Money)
local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)

local selectors = CollectionService:GetTagged(Tags.RIDE_SELECTOR.ROOT)

function display(textLabel: TextLabel, message: string)
	textLabel.Text = message
	task.wait(Constants.RIDE_SELECTOR.MESSAGE_DEBOUNCE)
end

function setUp(selector: Model)
	local interface = Utils.findFirstTaggedDescendant(selector, Tags.RIDE_SELECTOR.INTERFACE) :: SurfaceGui
	local trigger = Utils.findFirstTaggedDescendant(selector, Tags.RIDE_SELECTOR.TRIGGER) :: ClickDetector
	local selected = interface.Selected :: ObjectValue

	Utils.connectWithMutex(trigger.MouseClick, function(player: Player)
		local textField = interface.TextField :: TextLabel

		if selected.Value == nil then
			Utils.withRestorePrevious(textField, "Text", function()
				display(textField, "SELECT RIDE!!! >:((") -- TODO: Move to attributes?
			end)
			return
		end

		if not pcall(Money.substract, player, Constants.RIDE_SELECTOR.PAYMENT_AMOUNT) then --TODO: Bit ugly?
			Utils.withRestorePrevious(textField, "Text", function()
				display(textField, "You're 2 broke :P") -- TODO: Move to attributes?
			end)
			return
		end

		Utils.withRestorePrevious(textField, "Text", function()
			local messages = {
				"Starting in...", -- TODO: Move to attributes?
				"3",
				"2",
				"1",
			}
			for _, message in ipairs(messages) do
				display(textField, message)
			end
		end)

		Utils.withRestorePrevious(selector, "Parent", function()
			selector.Parent = nil

			local movementEvent = selected.Value.Fire :: RemoteEvent
			movementEvent:FireAllClients()

			task.wait(Constants.RIDE_SELECTOR.DISSAPEAR_DEBOUNCE)
		end)
	end)
end

for _, selector: Model in ipairs(selectors) do
	setUp(selector)
end
