local Knit = require(game:GetService("ReplicatedStorage").Packages.knit)
local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal  = require(ReplicatedStorage.Packages.Signal)

local RoundService = Knit.CreateService {
    Name = "RoundService";
    Client = {};
}

RoundService.PlayersToStartRound = 1
RoundService.RoundTime = 5
RoundService.IntermissionTime = 5
RoundService.IsInMatch = false
RoundService.States = {
    Intermission = "Intermission",
    InMatch = "InMatch",
    AfterMatch = "AfterMatch",
    WaitingForPlayers = "WaitingForPlayers", 
}

RoundService.ChangeState = Signal.new()





function RoundService:_OnIntermission()

    for curretTime = self.IntermissionTime, 0, -1 do
        print("IntermissionTime:", curretTime)
        task.wait(1)

        if curretTime < 1 then
            print("Intermission over, waiting for players")
            self.ChangeState:Fire(self.States.WaitingForPlayers)
        end
    end
end

function RoundService:_OnWaitForPlayers()
        while #Players:GetPlayers() < self.PlayersToStartRound do
            task.wait(1)
            print("Waiting for players")
        end

        print("Enough Players, starting round")
        self.ChangeState:Fire(self.States.InMatch)
end

function RoundService:_StartMatchTimer()
    for time = self.RoundTime, 0, -1 do
        print(time, "Seconds until round ends")
        task.wait(1)

        if time < 1 then
            print("round over")
            self.ChangeState:Fire(self.States.AfterMatch)
        end
    end
end

function RoundService:_SpawnKillBricks()
    repeat
        local xOffset = math.random(-100, 100)
        local zOffset = math.random(-100, 100)
        local newKillbrick = Instance.new("Part")
        CollectionService:AddTag(newKillbrick, "KillBrick")
        newKillbrick.Position = Vector3.new(xOffset, 100, zOffset)
        newKillbrick.Parent = workspace
        task.wait(.1)
    until self.IsInMatch == false
end

function RoundService:_CleanUpArena()
    print("cleaning")
    for _, killBrick in ipairs(CollectionService:GetTagged("KillBrick")) do
        killBrick:Destroy()
    end

    self.ChangeState:Fire(self.States.Intermission)
end

function RoundService:KnitStart()
    self.ChangeState:Connect(function(state)
        if state == self.States.Intermission then
            self:_OnIntermission()

        elseif state == self.States.WaitingForPlayers then
            self:_OnWaitForPlayers()

        elseif state == self.States.InMatch then
            self.IsInMatch = true
            self:_StartMatchTimer()

        elseif state == self.States.AfterMatch then
            self.IsInMatch = false
            self:_CleanUpArena()
        end
    end)

    self.ChangeState:Connect(function(state)
        if state == self.States.InMatch then
            self:_SpawnKillBricks()
        end
    end)



    self.ChangeState:Fire(self.States.Intermission)

end


return RoundService
