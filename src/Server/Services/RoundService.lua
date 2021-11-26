local Knit = require(game:GetService("ReplicatedStorage").Packages.Knit)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal  = require(ReplicatedStorage.Packages.Signal)

local RoundService = Knit.CreateService {
    Name = "RoundService";
    Client = {
        StartMatchSignal = Signal.new(),
        WaitForPlayersSignal = Signal.new(),
        StartIntermissionSignal = Signal.new(),
        StopMatchSignal = Signal.new(),

    };
}

RoundService.PlayersToStartRound = 1
RoundService.RoundTime = 5
RoundService.IsInRound = false
RoundService.IntermissionTime = 5

function RoundService:OnIntermission()
    for curretTime = self.IntermissionTime, 0, -1 do
        print("IntermissionTime:", curretTime)
        task.wait(1)

        if curretTime < 1 then
            print("Intermission over, waiting for players")
            self.Client.WaitForPlayersSignal:Fire()
        end
    end
end

function RoundService:OnWaitForPlayers()
    while #Players:GetPlayers() < self.PlayersToStartRound do
        task.wait(1)
        print("Waiting for players")
    end

    print("Enough Players, starting round")
    self.Client.StartMatchSignal:Fire()
end

function RoundService:StartMatchTimer()
    for time = self.RoundTime, 0, -1 do
        print(time, "Seconds until round ends")
        task.wait(1)

        if time < 1 then
            print("round over")
            self.Client.StopMatchSignal:Fire()
        end
    end
end

function RoundService:SpawnKillBricks()
    repeat
        local xOffset = math.random(-100, 100)
        local zOffset = math.random(-100, 100)
        local newKillbrick = Instance.new("Part")
        CollectionService:AddTag(newKillbrick, "KillBrick")
        newKillbrick.Position = Vector3.new(xOffset, 100, zOffset)
        newKillbrick.Parent = workspace
        task.wait(.1)
    until self.IsInRound == false

end

function RoundService:CleanUpArena()
    print("cleaning")
    for _, killBrick in ipairs(CollectionService:GetTagged("KillBrick")) do
        killBrick:Destroy()
    end

    self.Client.StartIntermissionSignal:Fire()
end

function RoundService:_SetRoundStatus(status: boolean)
    self.IsInRound = status
end


function RoundService:KnitStart()
    self.Client.StartIntermissionSignal:Connect(function() 
        self:OnIntermission()
    end)

    self.Client.WaitForPlayersSignal:Connect(function() 
        self:OnWaitForPlayers()
    end)

    self.Client.StartMatchSignal:Connect(function() 
        self:StartMatchTimer()
    end)

    
    self.Client.StartMatchSignal:Connect(function()
        self:_SetRoundStatus(true) 
        self:SpawnKillBricks()
    end)

    self.Client.StopMatchSignal:Connect(function() 
        self:_SetRoundStatus(false) 
        self:CleanUpArena()
    end)

    self.Client.StartIntermissionSignal:Fire()

end


return RoundService
