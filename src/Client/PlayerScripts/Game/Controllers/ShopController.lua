local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.knit)
local ShopService

local ShopController = Knit.CreateController { Name = "ShopController" }

--! it would be interesting to fetch data from a module and construct the pet gui from it.



function ShopController:KnitStart()
    local Player: Player = Knit.Player
    
    local ShopGui: ScreenGui = Player.PlayerGui:WaitForChild("Shop")
    local ShopFrame: Frame = ShopGui.ShopFrame
    local ShopButton: GuiButton = ShopGui.ShopButton

    local PetsMenu: Frame = ShopGui.ShopFrame.PetsMenuFrame


    ShopFrame.Visible = false

    ShopButton.MouseButton1Click:Connect(function()
        ShopFrame.Visible = not ShopFrame.Visible
    end)

    for _, frame in ipairs(PetsMenu:GetChildren()) do
        if frame:IsA("Frame") then
            local textButton = frame:FindFirstChildWhichIsA("GuiButton")
            textButton.MouseButton1Click:Connect(function()
                ShopService.PurchaseAttempt:Fire(frame.Name)
            end)
        end
    end
end


function ShopController:KnitInit()
    ShopService = Knit.GetService("ShopService")
end


return ShopController
