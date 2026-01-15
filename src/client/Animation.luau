local RunService = game:GetService("RunService")

local Animation = {}
Animation.__index = Animation

type EasingFunction = (x: number) -> number

function Animation.new(
	part: Part,
	from: CFrame,
	to: CFrame,
	easingFunctions: { x: EasingFunction, y: EasingFunction, z: EasingFunction },
	duration: number
)
	local self = setmetatable({}, Animation)
	self.Part = part
	self.From = from
	self.To = to
	self.EasingFunctions = easingFunctions
	self.Duration = duration
	self.Connection = nil

	return self
end

function Animation:Trigger()
	local progress = 0 -- normalized progress, ranges from 0 to 1

	self.Connection = RunService.PreRender:Connect(function(deltaTime)
		progress = math.clamp(progress + deltaTime / self.Duration, 0, 1)

		self.Part.CFrame = self.From
			+ Vector3.new(
				(self.To.X - self.From.X) * self.EasingFunctions.x(progress),
				(self.To.Y - self.From.Y) * self.EasingFunctions.y(progress),
				(self.To.Z - self.From.Z) * self.EasingFunctions.z(progress)
			)

		if progress >= 1 then
			self:Stop()
		end
	end)
end

function Animation:Stop()
	if self.Connection then
		self.Connection:Disconnect()
		self.Connection = nil
	end
end

return Animation
