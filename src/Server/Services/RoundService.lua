local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal  = require(ReplicatedStorage.Packages.Signal)

local RoundService = Knit.CreateService {
    Name = "RoundService";
    Client = {};
}

RoundService.PlayersToStartRound = 1
RoundService.RoundTime = 10
RoundService.IsInRound = false
RoundService.IntermissionTime = 5

RoundService.StartRoundSignal = Signal.new()
RoundService.WaitForPlayersSignal = Signal.new()
RoundService.SpawnKillBricksSignal = Signal.new()
RoundService.StartIntermissionSignal = Signal.new()


function RoundService:StartIntermission()
    for time = self.IntermissionTime, 0, -1 do
        print("IntermissionTime:", time)
        task.wait(1)

        if time < 1 then
            print("Intermission over, waiting for players")
            self.WaitForPlayersSignal:Fire()
        end
    end
end

function RoundService:WaitForPlayers()
    repeat
        print("Waiting for players")
        task.wait(1)
    until  #Players:GetPlayers() >= self.PlayersToStartRound

    print("Enough Players, starting round")

    self.StartRoundSignal:Fire()
    self.SpawnKillBricksSignal:Fire()
end

function RoundService:StartRoundTimer()
    self.IsInRound = true

    for time = self.RoundTime, 0, -1 do
        print(time, "Until round ends")
        task.wait(1)

        if time < 1 then
            self.IsInRound = false
            print("round over")

            self.WaitForPlayersSignal:Fire()
        end
    end
end

function RoundService:SpawnKillBricks()
    while self.IsInRound do
        task.wait(.6)

        local xOffset = math.random(-100, 100)
        local zOffset = math.random(-100, 100)
        local newKillbrick = Instance.new("Part")
        CollectionService:AddTag(newKillbrick, "KillBrick")
        newKillbrick.Position = Vector3.new(xOffset, 100, zOffset)
        newKillbrick.Parent = workspace
    end
    
end


function RoundService:KnitStart()

    self.StartIntermissionSignal:Connect(function()
        self:StartIntermission()
    end)
    
    self.WaitForPlayersSignal:Connect(function()
        self:WaitForPlayers()
    end)

    self.StartRoundSignal:Connect(function()
        self:StartRoundTimer()
    end)


    self.SpawnKillBricksSignal:Connect(function()
        self:SpawnKillBricks()
    end)

    self.StartIntermissionSignal:Fire()

end


return RoundService
