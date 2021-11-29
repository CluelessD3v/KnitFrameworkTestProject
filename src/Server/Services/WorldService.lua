--[[
    This service is the class responsible for core game functionality
]]
local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local PlayerEntity = require(ServerScriptService.PlayerEntitiy)


local WorldService = Knit.CreateService {
    Name = "World";
    Client = {};
}

WorldService.PlayerEntities = {}

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


function WorldService:KnitStart()
    self:AddPlayerEntity()
    self:RemovePlayerEntity()
end
    

return WorldService


