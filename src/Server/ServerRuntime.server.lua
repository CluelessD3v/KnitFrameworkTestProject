local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Knit = require(ReplicatedStorage.Packages.knit)
local Component = require(ReplicatedStorage.Packages.Component)

Knit.AddServices(script.Parent.Services)

Knit.Start():andThen(function()
    Component.Auto(script.Parent.Components)
end):catch(warn)