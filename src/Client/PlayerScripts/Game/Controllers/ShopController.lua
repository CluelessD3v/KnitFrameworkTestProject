local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local ShopService

local ShopController = Knit.CreateController { Name = "ShopController" }


function ShopController:KnitStart()
    local Player: Player = Knit.Player
    
    local ShopGui: ScreenGui = Player.PlayerGui:WaitForChild("Shop")
    local ShopFrame: Frame = ShopGui.ShopFrame
    local ShopButton: GuiButton = ShopGui.ShopButton

    local PetsMenu: Frame = ShopGui.ShopFrame.PetsMenuFrame

    ShopButton.MouseButton1Click:Connect(function()
        ShopFrame.Visible = not ShopFrame.Visible
    end)

    for _, frame in ipairs(PetsMenu:GetChildren()) do
        if frame:IsA("Frame") then
            local textButton = frame:FindFirstChildWhichIsA("GuiButton")
            textButton.MouseButton1Click:Connect(function()
                ShopService.PurchaseAttempt:Fire()
            end)
        end
    end
end


function ShopController:KnitInit()
    ShopService = Knit.GetService("ShopService")
end


return ShopController
