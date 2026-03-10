local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)

workspace.PersistentLoaded:Wait()

local buttons = CollectionService:GetTagged(Tags.BUTTON_ANIMATION)

for _, button in ipairs(buttons) do
	local animation = Utils.findFirstTaggedDescendant(button, Tags.MOVEMENT.ROOT)

	if animation then
		local clickDetector = button.Button.ClickDetector :: ClickDetector
		local event = Utils.findFirstTaggedDescendant(animation, Tags.MOVEMENT.TRIGGER) :: BindableEvent

		clickDetector.MouseClick:Connect(function()
			event:Fire()
		end)
	end
end
