local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

local Tags = require(ReplicatedStorage.Tags)

local CLICK_ANIMATION_NAME = "ClickAnimation"

workspace.PersistentLoaded:Wait()

local buttons = CollectionService:GetTagged(Tags.BUTTON_ANIMATION)

for _, button in ipairs(buttons) do
	local animation = button:FindFirstChild(CLICK_ANIMATION_NAME)

	if animation then
		local clickDetector = button.Button.ClickDetector :: ClickDetector
		local event = animation.Fire :: BindableEvent

		clickDetector.MouseClick:Connect(function()
			event:Fire()
		end)
	end
end
