local _, ADDON = ...

local playerProfessions
--see https://wow.gamepedia.com/TradeSkillLineID for all skillIds
local function playerHasProfession(skillId)

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
local function playerIsClass(class)
    if playerClass == nil then
        playerClass = select(2, UnitClass("player"))
    end

    return playerClass == class
end

local playerRace
-- see https://wow.gamepedia.com/API_UnitRace for all race names
local function playerIsRace(race)
    if playerRace == nil then
        playerRace = select(2, UnitRace("player"))
    end

    return playerRace == race
end

local playerCovenant
local function playerIsCovenant(covenantId)
    if playerCovenant == nil then
        playerCovenant = C_Covenants.GetActiveCovenantID()
    end

    return playerCovenant == covenantId
end

local playerFaction
-- factionID=0 for Horde
-- factionID=1 for Alliance
local function playerIsFaction(factionID)
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

local playerHasRiding
local function playerCanRide(mountId)
    if playerHasRiding == nil then
        playerHasRiding = IsSpellKnown(33388) or IsSpellKnown(33391) or IsSpellKnown(34090) or IsSpellKnown(34091) or IsSpellKnown(90265)  -- Riding skills
    end

    if playerHasRiding then
        return true
    end

    -- without riding skill you can only ride heirloom chopper and sea or riding turtle
    if mountId == 678 or mountId == 679 or mountId == 125 or mountId ~= 312 then
        return true
    end

    return false
end

local Mapping = {
    class = playerIsClass,
    race = playerIsRace,
    skill = playerHasProfession,
    covenant = playerIsCovenant,
    quest = C_QuestLog.IsQuestFlaggedCompleted,
}

function ADDON.IsPersonalMount(mountId, faction)
    if false == playerCanRide(mountId) then
        return false
    end

    if faction ~= nil and false == playerIsFaction(faction) then
        return false
    end

    local restrictions = ADDON.DB.Restrictions[mountId]
    if restrictions then
        for type, values in pairs(restrictions) do
            local checkSuccess = false
            local checkFunc = Mapping[type]
            for _, value in ipairs(values) do
                if true == checkFunc(value) then
                    checkSuccess = true
                    break
                end
            end
            if false == checkSuccess then
                return false
            end
        end
    end

    return true
end