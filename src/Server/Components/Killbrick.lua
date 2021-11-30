local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Maid = require(ReplicatedStorage.Packages.maid)
local Option = require(ReplicatedStorage.Packages.Option)


local Component = require(game:GetService("ReplicatedStorage").Packages.Component)

local KillBrick = Component.new({
  Tag = "KillBrick",
  Ancestors = {workspace},
  Extensions = {}
})

function  KillBrick:Construct()    
    self.Maid = Maid.new()
    self.Maid:AddTask(self.Instance)

    self.Instance.Size = Vector3.new(4,4,4)
    self.Instance.Material = Enum.Material.Neon
    self.Instance.BrickColor = BrickColor.new("Really red")
    self.Instance.Parent = workspace
end

function KillBrick:GetHumanoidFromTouchedPart(touchedPart)
  local humanoid: Humanoid = touchedPart.Parent:FindFirstChild("Humanoid") 

  return Option.Wrap(humanoid)
end

function KillBrick:IfTouchedByHumanoidKillIt()
	self.Maid:AddTask(self.Instance.Touched:Connect(function(theTouchedPart)
		local db: boolean = false

		if db == false then
			db = true

			self:GetHumanoidFromTouchedPart(theTouchedPart):Match{
				Some = function(humanoid)
          humanoid.Health = 0          
				end,

				None = function() end
			}

			task.wait(1)
			db = false
		end   
	end))
end

function KillBrick:Start()
  Debris:AddItem(self.Instance, 5)
  self:IfTouchedByHumanoidKillIt()
end

function KillBrick:Stop()

end

return KillBrick



