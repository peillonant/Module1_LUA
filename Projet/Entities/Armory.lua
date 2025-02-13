local myAbilities = require("Entities/Ability")

local armory = {}

armory.typeWeapon = {
    RANGE = "RANGE",
    CLOSE = "CLOSE",
    MAGIC = "MAGIC"
}

armory.BAREHANDED = {
    type = armory.typeWeapon.RANGE,
    dmg = 2,
    range = 50,
    cooldown = .5,
    bulletSpeed = 5,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/fist.png"),
    ability = nil
}

armory.CLUB = {
    type = armory.typeWeapon.CLOSE,
    dmg = 5,
    range = math.pi / 3,
    cooldown = 1.5,
    bulletSpeed = 1,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/clubWood.png"),
    ability = myAbilities.TANK
}

armory.SPEAR = {
    type = armory.typeWeapon.RANGE,
    dmg = 3,
    range = 200,
    cooldown = 0.5,
    bulletSpeed = 10,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/spearWood.png"),
    ability = myAbilities.DASH
}

armory.WAND = {
    type = armory.typeWeapon.MAGIC,
    dmg = 10,
    range = 350,
    cooldown = 3,
    bulletSpeed = 2.5,
    AOERange = 50,
    imgTileSheetBullet = love.graphics.newImage("Asset/Character/Weapon/Bullet/wandWood.png"),
    ability = myAbilities.TOTEMHEALT
}

armory.ListWeapon = {armory.CLUB, armory.SPEAR, armory.WAND}
return armory
