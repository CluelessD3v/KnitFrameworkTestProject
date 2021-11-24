local ReplicatedStorage = game:GetService("ReplicatedStorage")
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

    self.Maid:AddTask(function()
        print("destroyed")
    end)
    return self
end

function KillBrick:Init()
     self.Maid:AddTask(self.Instance.Touched:Connect(function(theTouchedPart)
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
    end))
end

function KillBrick:Destroy()
    self.Maid:Cleanup()
end

return KillBrick

