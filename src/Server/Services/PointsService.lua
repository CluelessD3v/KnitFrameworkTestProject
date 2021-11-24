local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Players = game:GetService("Players")

local RoundService 


local PointsService = Knit.CreateService {
    Name = "PointsService";
    Client = {};
}


function PointsService:IncreasePoints(player)


end

function PointsService:DecreasePoints(player)
    local humanoid: Humanoid = player.Character.Humanoid

    humanoid.Died:Connect(function()
        print(player, "Died")
    end)
end

function PointsService:KnitStart()

    RoundService.StartRoundSignal:Connect(function()
        print("start")
        

        for _, player in ipairs(Players:GetPlayers()) do
            self:DecreasePoints(player)
        end
    end)
end


function PointsService:KnitInit()
    RoundService = Knit.GetService("RoundService") 
end


return PointsService
