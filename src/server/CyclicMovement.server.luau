local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Steps = require(ReplicatedStorage.Animation.Steps)

local CYCLICAL_ANIMATION_TAG = "cyclical"

workspace.PersistentLoaded:Wait()

local events = CollectionService:GetTagged(CYCLICAL_ANIMATION_TAG)

for _, event in ipairs(events) do
	task.spawn(function()
		while true do
			local points = event.Parent.Path:GetChildren()
			local steps = Steps.fromPoints(points)

			local duration = 0
			for _, step in ipairs(steps) do
				duration += step.duration
			end

			event:FireAllClients()

			if event.Parent:HasTag("cycle") then
				task.wait(duration * 2)
			else
				task.wait(duration)
			end
		end
	end)
end
