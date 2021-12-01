local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)

local ShopService = Knit.CreateService {
    Name = "ShopService";
    Client = {
        PurchaseAttempt = Knit.CreateSignal()
    };
}


function ShopService:KnitStart()
    self.Client.PurchaseAttempt:Connect(function() 
        print("fired")
    end)
end


function ShopService:KnitInit()
    
end


return ShopService
