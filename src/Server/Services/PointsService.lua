local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local RoundService 


local PointsService = Knit.CreateService {
    Name = "PointsService";
    Client = {};
}


function PointsService:KnitStart()
    RoundService.StartRoundSignal:Connect(function()
    end)
end


function PointsService:KnitInit()
    RoundService = Knit.GetService("RoundService") 
end


return PointsService
