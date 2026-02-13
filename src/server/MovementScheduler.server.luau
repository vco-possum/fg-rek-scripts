local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MovePlatformEvent = ReplicatedStorage:FindFirstChild("MovePlatformEvent")
while task.wait(12) do -- TODO: Change so that server creates steps and sends them to client
	MovePlatformEvent:FireAllClients()
end
