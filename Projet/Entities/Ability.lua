local myEntityState = require("MAE/EntitiesState")
local generalMethod = require("GeneralMethod")

local abilities = {}

local localCharact


local function ActiveRage(myAbility, myCharact)
    myCharact.ability.rage.onRage = true
    myCharact.ability.rage.tmpBonusDMG = myCharact.bonusDMG
    myCharact.ability.rage.tmpBonusSpeed = myCharact.bonusSpeed
    myCharact.ability.rage.tmpBonusCd = myCharact.bonusCd

    myCharact.bonusDMG = myAbility.rarity[myCharact.weaponRarityIndex].bonusDMG
    myCharact.bonusSpeed = myAbility.rarity[myCharact.weaponRarityIndex].bonusSpeed
    myCharact.bonusCd = myAbility.rarity[myCharact.weaponRarityIndex].bonusCD
end

-- Changer pour l'utilisation des angles
local function ActiveDash(myAbility, myCharact)
    if (myCharact.angle == - math.pi / 2) then
        myCharact.ability.dash.vy = - myAbility.rarity[myCharact.weaponRarityIndex].velocity
    elseif (myCharact.angle == 0) then
        myCharact.ability.dash.vx = myAbility.rarity[myCharact.weaponRarityIndex].velocity
    elseif (myCharact.angle == math.pi / 2) then
        myCharact.ability.dash.vy = myAbility.rarity[myCharact.weaponRarityIndex].velocity
    elseif (myCharact.angle == math.pi) then
        myCharact.ability.dash.vx = - myAbility.rarity[myCharact.weaponRarityIndex].velocity
    end
end

local function ReceiveDmg(dmgReceived)
    if (#localCharact.ability.totem > 0) then
        local totem = localCharact.ability.totem[1]
        if (not totem.mercyBool) then
            totem.hp = totem.hp - dmgReceived
            totem.mercyBool = true
            totem.state = myEntityState.HIT
        end
    end
end

local function ActiveTotem(myAbility, myCharact)
    localCharact = myCharact

    if (#myCharact.ability.totem == 0) then
        local newTotem = {}
        newTotem.px = myCharact.px
        newTotem.py = myCharact.py
        newTotem.hp = myAbility.rarity[myCharact.weaponRarityIndex].lifeTotem
        newTotem.hpMax = myAbility.rarity[myCharact.weaponRarityIndex].lifeTotem
        newTotem.lifeDelay = myAbility.rarity[myCharact.weaponRarityIndex].lifeDelay
        newTotem.lifeTimer = 0
        newTotem.currentFrame = 1
        newTotem.timeSinceLastChangeImage = 0
        newTotem.delayImage = 0.1
        newTotem.mercyBool = false
        newTotem.mercyTimer = 0
        newTotem.room = generalMethod.currentRoom
        newTotem.state = myEntityState.IDLE
        newTotem.type = myEntityState.type.TOTEM

        newTotem.ReceiveDmg = ReceiveDmg

        table.insert(myCharact.ability.totem, newTotem)
    end
end


abilities.RAGE = {
    name = "RAGE",
    imgTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Rage.png"),
    rarity = {
        {cooldown = 5, timerRage = 2.5, bonusDMG = 2, bonusSpeed = 0.5, bonusCD = 0.8},
        {cooldown = 4.5, timerRage = 2.75, bonusDMG = 2.25, bonusSpeed = 0.75, bonusCD = 0.75},
        {cooldown = 4, timerRage = 3, bonusDMG = 2.5, bonusSpeed = 1, bonusCD = 0.7}
    },
    useAbility = ActiveRage
}


abilities.DASH = {
    name = "DASH",
    imgTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Dash.png"),
    rarity = {
        {cooldown = 3, velocity = 50},
        {cooldown = 2.5, velocity = 6},
        {cooldown = 2, velocity = 7}
    },
    useAbility = ActiveDash
}

abilities.TOTEMTAUNT = {
    name = "TOTEMTAUNT",
    imgTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Taunt.png"),
    rarity = {
        {cooldown = 5, lifeTotem = 10, lifeDelay = 5, totemTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Dummy.png")},
        {cooldown = 4.5, lifeTotem = 15, lifeDelay = 10, totemTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Dummy.png")},
        {cooldown = 5, lifeTotem = 20, lifeDelay = 15, totemTileSheet = love.graphics.newImage("Asset/Character/Weapon/Ability/Dummy.png")}
    },
    useAbility = ActiveTotem

    
}

return abilities
