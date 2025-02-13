local generalMethod = require("GeneralMethod")
local myArmory = require("Entities/Armory")

local bestiary = {}

bestiary.type = {
    NORMAL = "NORMAL",
    ELITE = "ELITE",
    BOSS = "BOSS"
}

bestiary.DUMMIES = {
    hpMAX = 10,
    dmg = 0,
    rangeDMG = 1000,
    rangeSearch = 1000,
    cooldown = 1000,
    moveSpeed = 0,
    hitBox = (generalMethod.TILE_WIDTH / 2),
    imgTileSheet = love.graphics.newImage(
        "Asset/Bestiaire/AGE_" .. tostring(generalMethod.currentLevel) .. "/Dummy.png"
    ),
    weaponType = myArmory.typeWeapon.CLOSE,
    bulletSpeed = 0,
    indexFrame = {
        walkingStart = 1,
        walkingEnd = 4,
        hitStart = 1,
        hitEnd = 4,
        attackStart = 1,
        attackEnd = 1,
        indexBullet = 0
    }
}

bestiary.SLIMBLUE = {
    hpMAX = 15,
    dmg = 2,
    rangeDMG = 50,
    rangeSearch = 200,
    cooldown = 2,
    moveSpeed = 2.5,
    hitBox = (generalMethod.TILE_WIDTH / 2),
    imgTileSheet = love.graphics.newImage(
        "Asset/Bestiaire/AGE_" .. tostring(generalMethod.currentLevel) .. "/SlimeBlue.png"
    ),
    weaponType = myArmory.typeWeapon.RANGE,
    bulletSpeed = 2.5,
    indexFrame = {
        walkingStart = 2,
        walkingEnd = 8,
        hitStart = 13,
        hitEnd = 15,
        attackStart = 9,
        attackEnd = 13,
        indexBullet = 17
    }
}

bestiary.WITCH = {
    hpMAX = 30,
    dmg = 3,
    rangeDMG = 150,
    rangeSearch = 300,
    cooldown = 4,
    moveSpeed = 1.5,
    hitBox = (generalMethod.TILE_WIDTH / 2),
    imgTileSheet = love.graphics.newImage(
        "Asset/Bestiaire/AGE_" .. tostring(generalMethod.currentLevel) .. "/Witch.png"
    ),
    weaponType = myArmory.typeWeapon.RANGE,
    bulletSpeed = 5,
    indexFrame = {
        walkingStart = 1,
        walkingEnd = 4,
        hitStart = 4,
        hitEnd = 4,
        attackStart = 4,
        attackEnd = 8,
        indexBullet = 9
    }
}

return bestiary
