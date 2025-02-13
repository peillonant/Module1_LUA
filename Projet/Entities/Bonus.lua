local myCharact

local bonus = {}

bonus.type = {
    WEAPON = "WEAPON",
    BONUS = "BONUS",
    POTION = "POTION"
}

function bonus.InitBonus(localCharact)
    myCharact = localCharact
end

local function UsePotion(buff)
    myCharact.hp = myCharact.hp + buff

    if (myCharact.hp > myCharact.hpMax) then
        myCharact.hp = myCharact.hpMax
    end
end

local function UseShield(buff)
    myCharact.shield = myCharact.shield + buff

    if (myCharact.shield * 2 > myCharact.hpMax) then
        myCharact.shield = math.ceil(myCharact.hpMax / 2)
    end
end

local function UseLifeUp(buff)
    myCharact.hpMax = myCharact.hpMax + buff
    myCharact.hp = myCharact.hp + buff

    if (myCharact.hpMax > myCharact.hpLimit) then
        myCharact.hpMax = myCharact.hpLimit
    end

    if (myCharact.hp > myCharact.hpMax) then
        myCharact.hp = myCharact.hpMax
    end
end

local function UseDmgUp(buff)
    myCharact.bonusDMG = myCharact.bonusDMG + buff
end

local function UseSpeedUp(buff)
    myCharact.bonusSpeed = myCharact.bonusSpeed + buff
    myCharact.speed = myCharact.speed + buff
end

bonus.POTION = {
    type = bonus.type.POTION,
    name = "Heal",
    tileSheet = love.graphics.newImage("Asset/Item/healt_potion.png"),
    buff = 5,
    useBonus = UsePotion
}

bonus.SHIELD = {
    type = bonus.type.BONUS,
    name = "Shield",
    tileSheet = love.graphics.newImage("Asset/Item/shield.png"),
    buff = 1,
    useBonus = UseShield
}

bonus.LIFEUP = {
    type = bonus.type.BONUS,
    name = "Life +1",
    tileSheet = love.graphics.newImage("Asset/Item/life_up.png"),
    buff = 2,
    useBonus = UseLifeUp
}

bonus.DMGUP = {
    type = bonus.type.BONUS,
    name = "DMG Up",
    tileSheet = love.graphics.newImage("Asset/Item/damage_up.png"),
    buff = 10,
    useBonus = UseDmgUp
}

bonus.SPEEDUP = {
    type = bonus.type.BONUS,
    name = "SPD Up",
    tileSheet = love.graphics.newImage("Asset/Item/shoes_up.png"),
    buff = 3,
    useBonus = UseSpeedUp
}

bonus.listItem = {bonus.POTION, bonus.SHIELD, bonus.LIFEUP, bonus.DMGUP, bonus.SPEEDUP}

return bonus
