local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Maid = require(ReplicatedStorage.Packages.maid)

local Killbrick = {}
Killbrick.__index = Killbrick

Killbrick.Tag = "Killbrick"

function Killbrick.new(instance)
    local self = setmetatable({}, Killbrick)
    print("Killbrick created")

    self.Maid = Maid.new()
    self.Instance = instance
    self.Maid:AddTask(self.Instance)

    self.Maid:AddTask(function()
        print("destroyed")
    end)
    return self
end

function Killbrick:Init()
    print("Init")

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
            db = true
        end
    end))
end

function Killbrick:Destroy()
    self.Maid:Cleanup()
end

return Killbrick

