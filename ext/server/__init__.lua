require 'config'

local humanTeamId = 2
local botTeamId = 1

Events:Subscribe('Level:Loaded', function(levelName, gameMode, round, roundsPerMap)
    DisableTeamSwitching()

    print("Team selection mode = " .. teamMode)

    if teamMode == 1 then
        SetHumanTeam(math.random(1, 2))
    elseif teamMode == 2 then
        SwapTeams()
    elseif teamMode == 3 then
        SetHumanTeam(1)
    elseif teamMode == 4 then
        SetHumanTeam(2)
    end

    PrintHumanTeam()
    print("Squad size = " .. squadSize)

    BalanceAllPlayers()
end)


Events:Subscribe('Player:TeamChange', function(player, team, squad)
    BalancePlayer(player)
end)

function BalancePlayer(player)
    if player == nil then
        return
    end

    if player.onlineId == 0 or player.guid == 0 then
        return
    else
        if player.teamId ~= humanTeamId then
            player.teamId = humanTeamId
        else
            return
        end
    end

    if player.squadId == 0 or player.squadId == 33 then
        FindSquad(player)
    end

    print("Moved " .. player.name .. " to team '" .. player.teamId .. "' squad '" .. player.squadId .. "'")
end

function BalanceAllPlayers()
    for i,player in ipairs(PlayerManager:GetPlayers()) do
        BalancePlayer(player)
    end
end

function FindSquad(player)
    for i=1,32 do
        if TeamSquadManager:GetSquadPlayerCount(player.teamId, i) < squadSize then
            player.squadId = i
            break
        end
    end
end

function SetHumanTeam(team)
    if team == 1 then
        humanTeamId = 1
        botTeamId = 2
    else
        humanTeamId = 2
        botTeamId = 1
    end
end

function SwapTeams()
    local tempHumanId = humanTeamId
    local tempBotId = botTeamId

    humanTeamId = tempBotId
    botTeamId = tempHumanId
end

function PrintHumanTeam()
    if humanTeamId == 1 then
        print("Human team = US")
    else
        print("Human team = RU")
    end
end

function DisableTeamSwitching()
    local s_SyncedBFSettings = ResourceManager:GetSettings("SyncedBFSettings")
	if s_SyncedBFSettings ~= nil then
		s_SyncedBFSettings = SyncedBFSettings(s_SyncedBFSettings)
        s_SyncedBFSettings.teamSwitchingAllowed = false
	end
end