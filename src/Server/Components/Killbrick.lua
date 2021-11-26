local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Maid = require(ReplicatedStorage.Packages.maid)
local Option = require(ReplicatedStorage.Packages.Option)


local KillBrick = {}
KillBrick.__index = KillBrick

KillBrick.Tag = "KillBrick"

function KillBrick.new(instance)
    local self = setmetatable({}, KillBrick)

    self.Maid = Maid.new()
    self.Instance = instance
    self.Maid:AddTask(self.Instance)

    self.Instance.Size = Vector3.new(4,4,4)
    self.Instance.Material = Enum.Material.Neon
    self.Instance.BrickColor = BrickColor.new("Really red")
    self.Instance.Parent = workspace

    Debris:AddItem(self.Instance, 5)
    return self
end

function KillBrick:GetHumanoidFromTouchedPart(touchedPart)
    local humanoid: Humanoid = touchedPart.Parent:FindFirstChild("Humanoid") 

    return Option.Wrap(humanoid)
end

function KillBrick:DecreaseHumanoidHealth(humanoid) 
    humanoid.Health = 0
end

function KillBrick:ListenForTouches()
	self.Maid:AddTask(self.Instance.Touched:Connect(function(theTouchedPart)
		local db: boolean = false

		if db == false then
			db = true

			self:GetHumanoidFromTouchedPart(theTouchedPart):Match{
				Some = function(humanoid)
					self:DecreaseHumanoidHealth(humanoid)
				end,

				None = function() end
			}

			task.wait(1)
			db = false
		end   
	end))
end

function KillBrick:Init()
    self:ListenForTouches()
end

function KillBrick:Destroy()
end

return KillBrick

