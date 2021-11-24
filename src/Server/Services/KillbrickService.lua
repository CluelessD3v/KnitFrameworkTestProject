local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local CollectionService = game:GetService("CollectionService")

local KillbrickService = Knit.CreateService {
    Name = "KillbrickService";
    Client = {};
}


function KillbrickService:SpawnKillBricks()
    for _ = 1, 10 do
        task.wait(.3)
        local xOffset = math.random(0, 100)
        local zOffset = math.random(0, 100)
        local newKillbrick = Instance.new("Part")
        CollectionService:AddTag(newKillbrick, "KillBrick")
        newKillbrick.Position = Vector3.new(xOffset, 100, zOffset)
        newKillbrick.Parent = workspace
    end
end


function KillbrickService:KnitStart()
    task.spawn(self.SpawnKillBricks, self)
    
end


function KillbrickService:KnitInit()
    
end


return KillbrickService
