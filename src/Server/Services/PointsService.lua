local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local RoundService 


local PointsService = Knit.CreateService {
    Name = "PointsService";
    Client = {};
}

PointsService.PointsReward = 10
PointsService.RewardInterval = 5
PointsService.PointsPenalty = 20


function PointsService:IncreasePoints(player)
    player.Data.Points.Value += self.PointsReward

end

function PointsService:DecreasePoints(player)
    local humanoid: Humanoid = player.Character.Humanoid

    humanoid.Died:Connect(function()
        player.Data.Points.Value -= self.PointsPenalty
        if player.Data.Points.Value < 1 then
            player.Data.Points.Value = 0
        end

    end)
end

function PointsService:KnitStart()

    RoundService.StartRoundSignal:Connect(function() 
        local startTime = time()       
        for _, player in ipairs(Players:GetPlayers()) do
            self:DecreasePoints(player)
        end

        RunService.Heartbeat:Connect(function()
            if time() - startTime > self.RewardInterval then

                for _, player in ipairs(Players:GetPlayers()) do
                    self:IncreasePoints(player)
                end

                startTime = time()
            end
        end)
        
    end)
end


function PointsService:KnitInit()
    RoundService = Knit.GetService("RoundService") 
end


return PointsService
