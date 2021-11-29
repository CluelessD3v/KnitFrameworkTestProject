local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Test = Knit.CreateController { Name = "Test" }


local PointsService

function Test:KnitStart()
    PointsService:ClientGetPoints(Knit.Player):andThen(function(points)
        print(points.Value)
    end)

end



function Test:KnitInit()
    PointsService = Knit.GetService("PointsService")
end


return Test
