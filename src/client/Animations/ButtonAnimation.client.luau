local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Tags = require(ReplicatedStorage.Tags)
local Utils = require(ReplicatedStorage.Utils)

workspace.PersistentLoaded:Wait()

local buttons = CollectionService:GetTagged(Tags.ANIMATED_BUTTON.ROOT)

for _, button in ipairs(buttons) do
	local event = Utils.findFirstTaggedDescendant(button, Tags.ANIMATED_BUTTON.ANIMATION_TRIGGER) :: BindableEvent
	local clickDetector = Utils.findFirstTaggedDescendant(button, Tags.ANIMATED_BUTTON.CLICK_DETECTOR) :: ClickDetector

	clickDetector.MouseClick:Connect(function()
		event:Fire()
	end)
end
