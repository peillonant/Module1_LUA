local sceneState = require("MAE/SceneState")
local myBonus = require("Entities/Bonus")
local generalMethod = require("GeneralMethod")

local sprite = {}

local function LoadFrame(spriteEntity)
    local nbColFrame = spriteEntity.TileSheet:getWidth() / generalMethod.TILE_WIDTH
    local nbLinFrame = spriteEntity.TileSheet:getHeight() / generalMethod.TILE_HEIGHT

    spriteEntity.frame = {}
    spriteEntity.frame[0] = nil
    local index = 1
    for l = 1, nbLinFrame do
        for c = 1, nbColFrame do
            spriteEntity.frame[index] =
                love.graphics.newQuad(
                (c - 1) * generalMethod.TILE_WIDTH,
                (l - 1) * generalMethod.TILE_HEIGHT,
                generalMethod.TILE_WIDTH,
                generalMethod.TILE_HEIGHT,
                spriteEntity.TileSheet:getWidth(),
                spriteEntity.TileSheet:getHeight()
            )
            index = index + 1
        end
    end
end

local function LoadCharacter(indexAge)
    sprite.charact = {}
    sprite.charact.TileSheet =
        love.graphics.newImage(
        "Asset/Character/AGE_" .. tostring(indexAge) .. "/Character_" .. tostring(indexAge) .. ".png"
    )

    LoadFrame(sprite.charact)
end

local function LoadHUD()
    sprite.HUD = {}
    sprite.HUD.charactHealth = {}
    sprite.HUD.charactHealth.TileSheet = love.graphics.newImage("Asset/Health/basic/heartsCharact.png")

    LoadFrame(sprite.HUD.charactHealth)
end

local function LoadEnemies(myEnemies)
    sprite.enemies = {}

    -- init the list of room on the sprite.enemie table
    for i = 1, myEnemies.nbrRooms do
        sprite.enemies[i] = {} -- tab of room

        for j = 1, #myEnemies[i] do
            sprite.enemies[i][j] = {}
            sprite.enemies[i][j].TileSheet = myEnemies[i][j].imgTileSheet
            LoadFrame(sprite.enemies[i][j])

            sprite.enemies[i][j].bullets = {}
            sprite.enemies[i][j].bullets.TileSheet = myEnemies[i][j].imgTileSheet
            LoadFrame(sprite.enemies[i][j].bullets)
        end
    end
end

local function LoadRoom()
    if (sprite.rooms == nil) then
        sprite.rooms = {}
    end

    sprite.rooms.TileSheet =
        love.graphics.newImage("Asset/Rooms/Level" .. tostring(generalMethod.currentLevel) .. "/Rooms.png")

    LoadFrame(sprite.rooms)
end

local function LoadItem()
    sprite.items = {}

    -- load Coin
    sprite.items.coins = {}
    sprite.items.coins.TileSheet = love.graphics.newImage("Asset/Item/coin_copper.png")
    LoadFrame(sprite.items.coins)

    -- load Bonus DMG_up
    sprite.items.dmgup = {}
    sprite.items.dmgup.TileSheet = myBonus.DMGUP.tileSheet
    myBonus.DMGUP.sprite = sprite.items.dmgup
    LoadFrame(sprite.items.dmgup)

    -- load Bonus Potion
    sprite.items.potion = {}
    sprite.items.potion.TileSheet = myBonus.POTION.tileSheet
    myBonus.POTION.sprite = sprite.items.potion
    LoadFrame(sprite.items.potion)

    -- load Bonus LifeUp
    sprite.items.lifeUp = {}
    sprite.items.lifeUp.TileSheet = myBonus.LIFEUP.tileSheet
    myBonus.LIFEUP.sprite = sprite.items.lifeUp
    LoadFrame(sprite.items.lifeUp)

    -- load Bonus Shield
    sprite.items.shield = {}
    sprite.items.shield.TileSheet = myBonus.SHIELD.tileSheet
    myBonus.SHIELD.sprite = sprite.items.shield
    LoadFrame(sprite.items.shield)

    -- load Bonus SpeedUP
    sprite.items.speedup = {}
    sprite.items.speedup.TileSheet = myBonus.SPEEDUP.tileSheet
    myBonus.SPEEDUP.sprite = sprite.items.speedup
    LoadFrame(sprite.items.speedup)
end

function sprite.LoadAGE(myEnemies)
    print("Loading the sprite Character for the AGE " .. generalMethod.currentLevel)
    LoadCharacter(generalMethod.currentLevel)

    LoadEnemies(myEnemies)

    LoadHUD()

    LoadItem()

    LoadRoom()

    if (sceneState.DEBUGGERMODE) then
        local nbrFrameLoad = 0

        for i = 1, myEnemies.nbrRooms do
            for j = 1, #myEnemies[i] do
                nbrFrameLoad = nbrFrameLoad + #sprite.enemies[i][j].frame
            end
        end

        nbrFrameLoad =
            nbrFrameLoad + #sprite.charact.frame + #sprite.HUD.charactHealth.frame + #sprite.rooms.frame +
            #sprite.items.coins.frame

        print(
            "End of the loading... for the AGE " ..
                generalMethod.currentLevel .. ". We have " .. tostring(nbrFrameLoad) .. " frames loaded"
        )
    end
end

function sprite.LoadCharacterWeapon(CharactWeapon)
    sprite.charact.bullets = {}
    sprite.charact.bullets.TileSheet = CharactWeapon.imgTileSheetBullet

    LoadFrame(sprite.charact.bullets)
end

function sprite.LoadTreasureItem(bonusItem)
    if (sprite.rooms == nil) then
        sprite.rooms = {}
    end

    sprite.rooms.TreasureRoom = {}
    sprite.rooms.TreasureRoom.TileSheet = bonusItem.weapon.imgTileSheetBullet

    LoadFrame(sprite.rooms.TreasureRoom)
end

return sprite
