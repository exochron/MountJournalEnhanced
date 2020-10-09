local ADDON_NAME, ADDON = ...

local playerProfessions
--see https://wow.gamepedia.com/TradeSkillLineID for all skillIds
function ADDON.playerHasProfession(skillId)

    if nil == playerProfessions then
        playerProfessions = {}
        local prof1, prof2 = GetProfessions()
        -- https://wow.gamepedia.com/TradeSkillLineID
        if prof1 then
            local prof1SkillID = select(7, GetProfessionInfo(prof1))
            if prof1SkillID then
                playerProfessions[prof1SkillID] = true
            end
        end
        if prof2 then
            local prof2SkillID = select(7, GetProfessionInfo(prof2))
            if prof2SkillID then
                playerProfessions[prof2SkillID] = true
            end
        end
    end

    return playerProfessions[skillId]
end

local playerClass
function ADDON.playerIsClass(class)
    if playerClass == nil then
        playerClass = select(2, UnitClass("player"))
    end

    return playerClass == class
end

local playerRace
-- see https://wow.gamepedia.com/API_UnitRace for all rece names
function ADDON.playerIsRace(race)
    if playerRace == nil then
        playerRace = select(2, UnitRace("player"))
    end

    return playerRace == race
end

local playerFaction
-- factionID=0 for Horde
-- factionID=1 for Alliance
function ADDON.playerIsFaction(factionID)
    if playerFaction == nil then
        playerFaction = UnitFactionGroup("player")
    end

    if factionID == 1 and playerFaction == "Alliance" then
        return true
    end
    if factionID == 0 and playerFaction == "Horde" then
        return true
    end

    return false
end