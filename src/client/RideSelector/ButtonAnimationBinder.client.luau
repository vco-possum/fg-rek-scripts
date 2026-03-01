local CollectionService = game:GetService("CollectionService")

local BUTTON_TAG = "button"

workspace.PersistentLoaded:Wait()

local buttons = CollectionService:GetTagged(BUTTON_TAG)

for _, button in ipairs(buttons) do
	local animation = button:FindFirstChild("ClickAnimation")

	if animation then
		local clickDetector = button.Button.ClickDetector :: ClickDetector
		local event = animation.Fire :: BindableEvent

		clickDetector.MouseClick:Connect(function()
			event:Fire()
		end)
	end
end
