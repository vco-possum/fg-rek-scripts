local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Steps = require(ReplicatedStorage.Animation.Steps)
local Tags = require(ReplicatedStorage.Tags)

workspace.PersistentLoaded:Wait()

local events = CollectionService:GetTagged(Tags.MOVEMENT.LOOP)

for _, event in ipairs(events) do
	task.spawn(function()
		while true do
			local points = event.Parent.Path:GetChildren()
			local steps = Steps.fromPoints(points)

			event:FireAllClients()

			local duration = Steps.totalDuration(steps)
			if event.Parent:HasTag(Tags.MOVEMENT.CYCLE) then
				task.wait(duration * 2)
			else
				task.wait(duration)
			end
		end
	end)
end
