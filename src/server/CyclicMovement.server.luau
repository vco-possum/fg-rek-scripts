local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Steps = require(ReplicatedStorage.Animations.Steps)
local Tags = require(ReplicatedStorage.Tags)

local function setUp(movement)
	local points = movement.Path:GetChildren()
	local steps = Steps.fromPoints(points)
	local duration = Steps.totalDuration(steps)

	while true do
		task.spawn(function()
			local trigger: RemoteEvent = movement.Fire
			trigger:FireAllClients()
		end)

		if movement:HasTag(Tags.MOVEMENT.LOOP_FOREVER) then
			task.wait(duration * 2)
		else
			task.wait(duration)
		end
	end
end

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(Tags.MOVEMENT.LOOP_FOREVER)

for _, movement in ipairs(movements) do
	setUp(movement)
end
