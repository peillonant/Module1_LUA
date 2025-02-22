local myAbilities = require("Entities/Ability")

local armory = {}

armory.typeWeapon = {
    RANGE = "RANGE",
    CLOSE = "CLOSE",
    MAGIC = "MAGIC"
}

armory.rarity = {
    COMMON = "COMMON",
    UNCOMMON = "UNCOMMON",
    RARE = "RARE"
}

armory.BAREHANDED = {
    type = armory.typeWeapon.RANGE,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/fist.png"),
    rarity = {{dmg = 2, range = 50, cooldown = 0.5, bulletSpeed = 5}},
    ability = nil
}

armory.CLUB = {
    type = armory.typeWeapon.CLOSE,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/clubWood.png"),
    rarity = {
        {dmg = 5, range = math.pi / 3, cooldown = 1.5, bulletSpeed = 1},
        {dmg = 10, range = math.pi / 2, cooldown = 1.25, bulletSpeed = 1.25},
        {dmg = 15, range = math.pi * 2 / 3, cooldown = 1, bulletSpeed = 1.5}
    },
    ability = myAbilities.RAGE
}

armory.SPEAR = {
    type = armory.typeWeapon.RANGE,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/spearWood.png"),
    rarity = {
        {dmg = 2, range = 200, cooldown = 0.5, bulletSpeed = 10},
        {dmg = 4, range = 250, cooldown = 0.5, bulletSpeed = 12.5},
        {dmg = 8, range = 300, cooldown = 0.5, bulletSpeed = 12.5}
    },
    ability = myAbilities.DASH
}

armory.WAND = {
    type = armory.typeWeapon.MAGIC,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/wandWood.png"),
    rarity = {
        {dmg = 10, range = 350, cooldown = 3, bulletSpeed = 2.5, AOERange = 50},
        {dmg = 15, range = 375, cooldown = 2.5, bulletSpeed = 3, AOERange = 75},
        {dmg = 20, range = 400, cooldown = 2, bulletSpeed = 3.5, AOERange = 75}
    },
    ability = myAbilities.TOTEMTAUNT
}

armory.ListWeapon = {armory.CLUB, armory.SPEAR, armory.WAND}
return armory
