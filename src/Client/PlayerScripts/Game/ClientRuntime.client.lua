local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Loader = require(ReplicatedStorage.Packages.Loader)

local Knit = require(ReplicatedStorage.Packages.knit)

Knit.AddControllers(script.Parent.Controllers)

Knit.Start():andThen(function()
    Loader.LoadChildren(script.Parent.Components)
end):catch(warn)