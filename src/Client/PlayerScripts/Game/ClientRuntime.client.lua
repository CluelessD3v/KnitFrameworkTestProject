local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local Component = require(ReplicatedStorage.Packages.Component)

Knit.AddControllers(script.Parent.Controllers)

Knit.Start():andThen(function()
    Component.Auto(script.Parent.Components)
end):catch(warn)