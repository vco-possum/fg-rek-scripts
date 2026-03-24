local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Constants = require(ReplicatedStorage.Constants)
local Interfaces = require(ReplicatedStorage.Interfaces)
local Money = require(ServerScriptService.Money)
local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)

local selectors = CollectionService:GetTagged(Tags.RIDE_SELECTOR.ROOT)

function display(textLabel: TextLabel, message: string)
	textLabel.Text = message
	task.wait(Constants.RIDE_SELECTOR.MESSAGE_DEBOUNCE)
end

function handlePayment(player: Player, interface: Interfaces.Interface, selected: ObjectValue)
	local textField = Utils.findFirstTaggedDescendant(interface, Tags.RIDE_SELECTOR.TEXT_WINDOW) :: TextLabel

	if selected.Value == nil then
		Utils.withRestoreProperty(textField, "Text", function()
			display(textField, "SELECT RIDE!!! >:((") -- NOTE: Move to attributes?
			error("Ride not selected")
		end)
		return
	end

	if not pcall(Money.substract, player, Constants.RIDE_SELECTOR.PAYMENT_AMOUNT) then --HACK: Bit ugly?
		Utils.withRestoreProperty(textField, "Text", function()
			display(textField, "You're 2 broke :P") -- NOTE: Move to attributes?
			error(`Player {player.Name} doesn't have enough money`)
		end)
		return
	end

	Utils.withRestoreProperty(textField, "Text", function()
		local messages = {
			"Starting in...", -- NOTE: Move to attributes?
			"3",
			"2",
			"1",
		}
		for _, message in ipairs(messages) do
			display(textField, message)
		end
	end)
end

local function firePlatform(selector, selected)
	Utils.withRestoreProperty(selector, "Parent", function()
		selector.Parent = nil

		local movementEvent = selected.Value.Fire :: RemoteEvent
		movementEvent:FireAllClients()

		task.wait(Constants.RIDE_SELECTOR.DISSAPEAR_DEBOUNCE)
	end)
end

function setUp(selector: Model)
	local interface = Utils.findFirstTaggedDescendant(selector, Tags.SELECTION_INTERFACE) :: SurfaceGui
	local trigger = Utils.findFirstTaggedDescendant(selector, Tags.RIDE_SELECTOR.TRIGGER) :: ClickDetector

	Utils.connectWithMutex(trigger.MouseClick, function(player: Player)
		local selected = interface.Selected :: ObjectValue

		local success = pcall(handlePayment, player, interface, selected)
		if success then
			firePlatform(selector, selected)
		end
	end)
end

for _, selector: Model in ipairs(selectors) do
	setUp(selector)
end
