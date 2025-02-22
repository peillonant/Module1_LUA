local sceneState = require("MAE/SceneState")
local myBonus = require("Entities/Bonus")
local myAbility = require("Entities/Ability")
local generalMethod = require("GeneralMethod")

local sprite = {}

------------------------ LOCAL FUNCTION CALLED BY ALL FUNCTION HERE ----------------------------------

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

----------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY LoadAGE FUNCTION ----------------------------------

local function LoadCharacter(indexAge)
    sprite.charact = {}
    sprite.charact.TileSheet =
        love.graphics.newImage(
        "Asset/Character/AGE_" .. tostring(indexAge) .. "/Character_" .. tostring(indexAge) .. ".png"
    )

    LoadFrame(sprite.charact)
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

    sprite.enemies.healthbar = {}
    sprite.enemies.healthbar.elite = {}
    sprite.enemies.healthbar.elite.TileSheet = love.graphics.newImage("Asset/Health/Bar/Monster_Elite.png")
    LoadFrame(sprite.enemies.healthbar.elite)

    sprite.enemies.healthbar.boss = {}
    sprite.enemies.healthbar.boss.TileSheet = love.graphics.newImage("Asset/Health/Bar/Monster_Boss.png")
    LoadFrame(sprite.enemies.healthbar.boss)
end

local function LoadHUD()
    sprite.HUD = {}
    sprite.HUD.charactHealth = {}
    sprite.HUD.charactHealth.TileSheet = love.graphics.newImage("Asset/Health/Basic/heartsCharact.png")

    LoadFrame(sprite.HUD.charactHealth)

    sprite.HUD.charactShield = {}
    sprite.HUD.charactShield.TileSheet = love.graphics.newImage("Asset/Health/Shield/shield.png")

    LoadFrame(sprite.HUD.charactShield)
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

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function to reset the variable tab
function sprite.ResetSprite()
    sprite = {}
end

-- Function called by GameManager InitGame
function sprite.LoadAGE(myEnemies)
    print("[SpriteManager] Loading the sprite Character for the AGE " .. generalMethod.currentLevel)

    LoadCharacter(generalMethod.currentLevel)

    LoadEnemies(myEnemies)

    LoadHUD()

    LoadItem()

    LoadRoom()

    if (sceneState.DEBUGGERMODE) then
        -- local nbrFrameLoad = 0

        -- for i = 1, myEnemies.nbrRooms do
        --     for j = 1, #myEnemies[i] do
        --         nbrFrameLoad = nbrFrameLoad + #sprite.enemies[i][j].frame
        --     end
        -- end

        -- nbrFrameLoad =
        --     nbrFrameLoad + #sprite.charact.frame + #sprite.HUD.charactHealth.frame + #sprite.rooms.frame +
        --     #sprite.items.coins.frame

        -- print(
        --     "[SpriteManager] End of the loading... for the AGE " ..
        --         generalMethod.currentLevel .. ". We have " .. tostring(nbrFrameLoad) .. " frames loaded"
        -- )
    end
end

-- Function called by CharacterManager on the Init and the ChangeWeapon
function sprite.LoadCharacterWeapon(myCharact)
    sprite.charact.bullets = {}
    sprite.charact.bullets.TileSheet = myCharact.weapon.imgTileSheetBullet

    LoadFrame(sprite.charact.bullets)

    if (myCharact.weapon.ability ~= nil) then

        sprite.charact.ability = {}
        sprite.charact.ability.TileSheet = myCharact.weapon.ability.imgTileSheet

        LoadFrame(sprite.charact.ability)

        if (myCharact.weapon.ability == myAbility.TOTEMTAUNT) then
            sprite.charact.ability.totem = {}
            sprite.charact.ability.totem.TileSheet = myCharact.weapon.ability.rarity[myCharact.weaponRarityIndex].totemTileSheet

            LoadFrame(sprite.charact.ability.totem)
        end
    end
end

-- Function called by LevelManager to load the Item on the TreasureRoom
function sprite.LoadTreasureItem(bonusItem)
    if (sprite.rooms == nil) then
        sprite.rooms = {}
    end

    sprite.rooms.TreasureRoom = {}
    sprite.rooms.TreasureRoom.TileSheet = bonusItem.weapon.imgTileSheetBullet

    LoadFrame(sprite.rooms.TreasureRoom)
end

-- Function called by LevelManager to load the Weapon on the BossItem
function sprite.LoadBossItem(bonusItem)
    if (sprite.rooms == nil) then
        sprite.rooms = {}
    end

    sprite.rooms.BossRoom = {}

    if (bonusItem.weapon) then
        sprite.rooms.BossRoom.TileSheet = bonusItem.weapon.imgTileSheetBullet
    else
        sprite.rooms.BossRoom.TileSheet = bonusItem.imgTileSheetBullet
    end

    LoadFrame(sprite.rooms.BossRoom)
end


return sprite
