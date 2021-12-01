--[[
    Custom player entity to set player related data abd custom behaviors
]]
local CollectionService = game:GetService("CollectionService")

local PlayerEntitiy = {}
PlayerEntitiy.__index = PlayerEntitiy

function PlayerEntitiy.new(player)
    local self = setmetatable({}, PlayerEntitiy)
    self.Instance = player
    
    CollectionService:AddTag(self.PlayerEntity, "Player")
    return self
end


function PlayerEntitiy:SetData()
    local data: Folder = Instance.new("Folder")
    data.Name = "Data"

    local points: NumberValue = Instance.new("NumberValue")
    points.Name = "Points"
    points.Value = 1000
    points.Parent = data

    data.Parent = self.Instance

end
return PlayerEntitiy