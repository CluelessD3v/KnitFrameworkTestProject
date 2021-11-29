local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Maid = require(ReplicatedStorage.Packages.maid)

local RoundService 


local PointsService = Knit.CreateService {
    Name = "PointsService";
    Client = {};
}

PointsService.Maid = Maid.new() 

PointsService.PointsReward = 10
PointsService.RewardInterval = 1
PointsService.PointsPenalty = 50

--* <---- PUBLIC METHODS ---->
function PointsService:IncreasePoints(player)
    player.Data.Points.Value += self.PointsReward

end

function PointsService:DecreasePoints(player)
    local humanoid: Humanoid = player.Character.Humanoid

    self.Maid:AddTask(humanoid.Died:Connect(function()
        player.Data.Points.Value -= self.PointsPenalty
        if player.Data.Points.Value < 1 then
            player.Data.Points.Value = 0
            print(player,"died")
        end

    end))
end

function PointsService.Client:ClientGetPoints(playerToLookUp)
    for _, player in ipairs(Players:GetPlayers()) do
        if player == playerToLookUp then return player.Data.Points end
    end
end


--* <---- PRIVATE METHODS ---->
function PointsService:_OnMatchStartedInit()
    
    local startTime = time()
    for _, player in ipairs(Players:GetPlayers()) do
        self:DecreasePoints(player)
    end


    self.Maid:AddTask(RunService.Heartbeat:Connect(function()
        if time() - startTime > self.RewardInterval then

            for _, player in ipairs(Players:GetPlayers()) do
                self:IncreasePoints(player)
            end

            startTime = time()
        end
    end))
end


function PointsService:_OnMatchEndedDeInit()
    self.Maid:Cleanup()
end


function PointsService:KnitStart()
    RoundService.ChangeState:Connect(function(state)
        if state  == RoundService.States.InMatch then
            self:_OnMatchStartedInit()
        elseif state == RoundService.States.AfterMatch then
            self:_OnMatchEndedDeInit()
        end
    end)
end

function PointsService:KnitInit()
    RoundService = Knit.GetService("RoundService") 
end


return PointsService
