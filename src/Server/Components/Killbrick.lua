local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local Maid = require(ReplicatedStorage.Packages.maid)

local KillBrick = {}
KillBrick.__index = KillBrick

KillBrick.Tag = "KillBrick"

function KillBrick.new(instance)
    local self = setmetatable({}, KillBrick)
    print("Killbrick created")

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

function KillBrick:Init()
     self.Instance.Touched:Connect(function(theTouchedPart)
        local db: boolean = false
        
        if db == false then
            db = true
            local humanoid: Humanoid = theTouchedPart.Parent:FindFirstChild("Humanoid") 

            if humanoid then
                humanoid.Health = 0
                self.Maid:Cleanup()
            end
            

            task.wait(1)
            db = false
        end   
    end)
end

function KillBrick:Destroy()
    print("Destroyed")
end

return KillBrick

