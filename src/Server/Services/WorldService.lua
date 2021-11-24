--[[
    This service is the class responsible for core game functionality
]]
local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local PlayerEntity = require(ServerScriptService.PlayerEntitiy)
local CollectionService = game:GetService("CollectionService")


local WorldService = Knit.CreateService {
    Name = "World";
    Client = {};
}


WorldService.PlayerEntities = {}
WorldService.RoundTime = 10

function WorldService:AddPlayerEntity()
    Players.PlayerAdded:Connect(function(player)
        local newPlayerEntity = PlayerEntity.new(player)
        table.insert(self.PlayerEntities, newPlayerEntity)
        newPlayerEntity:SetData()
    end)
end

function WorldService:RemovePlayerEntity()
    Players.PlayerRemoving:Connect(function(player)
        self.PlayerEntities[player] = nil
    end)
end

function WorldService:GetPlayerEntities()
    return self.PlayerEntities
end



function WorldService:SpawnKillBricks()
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

function WorldService:KnitStart()
    self:AddPlayerEntity()
    self:RemovePlayerEntity()
end
    

return WorldService
