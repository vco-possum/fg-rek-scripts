local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Steps = require(ReplicatedStorage.Animations.Steps)
local Tags = require(ReplicatedStorage.Tags)

local function setUp(movement)
	local points = movement.Path:GetChildren()
	local steps = Steps.fromPoints(points)
	local duration = Steps.totalDuration(steps)

	task.spawn(function()
		while true do
			local trigger: RemoteEvent = movement.Fire

			local serverTimestamp = workspace:GetServerTimeNow()
			trigger:FireAllClients(serverTimestamp)

			if movement:HasTag(Tags.MOVEMENT.CYCLE) then
				task.wait(duration * 2)
			else
				task.wait(duration)
			end
		end
	end)
end

workspace.PersistentLoaded:Wait()

local movements = CollectionService:GetTagged(Tags.MOVEMENT.LOOP_FOREVER)

for _, movement in ipairs(movements) do
	setUp(movement)
end
