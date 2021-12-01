local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local PetShopDataTable = require(ReplicatedStorage.PetShopDataTable)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {
        PurchaseAttempt = Knit.CreateSignal()
    };
}

function ShopService:KnitStart()
    self.Client.PurchaseAttempt:Connect(function(player, petName)
        local points = player.Data.Points

        if points.Value >= PetShopDataTable[petName].Price then
            points.Value -= PetShopDataTable[petName].Price
        end
    end)
end


function ShopService:KnitInit()
    
end


return ShopService
