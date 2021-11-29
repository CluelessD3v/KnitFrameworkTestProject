local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local HudController = Knit.CreateController { Name = "HudController" }
local RoundService

function HudController:KnitStart()
    local Player: Player = Knit.Player
    local Data = Player:WaitForChild("Data", 10)
    local HUD = Player.PlayerGui:WaitForChild("HUD", 10)
    Data.Points.Changed:Connect(function(newPoints)
        HUD.PointsCounterFrame.Counter.Text = tostring(newPoints)
    end)

    RoundService.ChangeStatus:Connect(function(status)
        HUD.StatusFrame.Status.Text = status
    end)

    RoundService.PlayerCountChanged:Connect(function(playerCount)
        HUD.PlayerCountFrame.PlayerCount.Text = playerCount
    end)

end

function HudController:KnitInit()
    RoundService = Knit.GetService("RoundService")
end


return HudController
