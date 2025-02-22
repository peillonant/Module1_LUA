local generalMethod = require("GeneralMethod")
local myArmory = require("Entities/Armory")
local myAbility = require("Entities/Ability")
local myState = require("MAE/EntitiesState")
local sceneState = require("MAE/SceneState")
local mySpriteManager = require("Game/SpriteManager")
local myBullets = require("Game/BulletsManager")
local myAudio = require("Game/AudioManager")
local mySettings = require("Menu/SettingsManager")

local charact = {}

-- Variable linked to the Input for the IMG
local delay = 0.1
local timeSinceLastInput = 0
local timeSinceLastChangeImage = 0

--------------------------- LOCAL FUNCTION LINKED TO CREATION  ----------------------------

-- Function to create the Character
local function CharactCreation()
    -- Position and Rotation of the Character
    charact.px = 200
    charact.py = 200
    charact.speed = 3
    charact.mvtUp = true
    charact.angle = 0

    -- Variable linked to the current state of the Charact
    charact.etat = myState.IDLE

    -- Variable linked to the "inventory"
    charact.weaponRarity = myArmory.rarity.COMMON
    charact.weaponRarityIndex = 1
    charact.weapon = myArmory.BAREHANDED
    charact.typeEntity = myState.type.CHARACTER
    charact.nbCoin = 5

    -- Varialbe linked to the current Image
    charact.currentIndexImage = 1

    -- Default setting
    charact.hpLimit = 20
    charact.hpMax = 10
    charact.hp = 10
    charact.shield = 0

    -- Variable Buff
    charact.bonusDMG = 0
    charact.bonusSpeed = 1
    charact.bonusCd = 1

    -- Variable linked to the ATK & ABL
    charact.hitBox = generalMethod.TILE_HEIGHT / 2
    charact.timerAttack = 0
    charact.timerAbility = 0
    charact.canATK = true
    charact.canABL = true
    charact.ability = {
        rage = {
            onRage = false,
            timerRage = 0,
            tmpBonusDMG = 0,
            tmpBonusSpeed = 0,
            tmpBonusCd = 0
        },
        dash = {
            vx = 0,
            vy = 0,
            trail = {}
        },
        totem = {}
    }

    -- Variable linked when the entity has been hit
    charact.mercyBool = false
    charact.mercyTimer = 0
    charact.mercyAlpha = 1

    -- Variable to know when the charact can retrieve the item
    charact.canGetItem = false
end

-------------------------------------------------------------------------------------------

-------------------------- LOCAL FUNCTION LINKED TO ABILITIES  ----------------------------

-- Function that manage the update of the image when it's hitten
local function UpdateTotemImage(totem, dt)

    if (totem.state == myState.HIT) then          
        local nbrFrame = #mySpriteManager.charact.ability.totem.frame

        totem.timeSinceLastChangeImage = totem.timeSinceLastChangeImage + dt
    
        if (totem.timeSinceLastChangeImage > totem.delayImage) then
            totem.currentFrame = totem.currentFrame + 1
            totem.timeSinceLastChangeImage = 0
        end

        if (totem.currentFrame > nbrFrame) then
            totem.currentFrame = 1
            totem.timeSinceLastChangeImage = 0            
        end
    end

end

-- Function that manage the Rage on the Character
local function AbilityRage(dt)
    charact.ability.rage.timerRage = charact.ability.rage.timerRage + dt

    if (charact.ability.rage.timerRage > charact.weapon.ability.rarity[charact.weaponRarityIndex].timerRage) then
        charact.bonusDMG = charact.ability.rage.tmpBonusDMG
        charact.bonusSpeed = charact.ability.rage.tmpBonusSpeed
        charact.bonusCd = charact.ability.rage.tmpBonusCd
        charact.ability.rage.timerRage = 0
        charact.ability.rage.onRage = false
    end
end

-- Function that manage the Dash [Moving, Create the Trail & Update the Trail]
local function AbilityDash(dt, myLevel)
    if (charact.ability.dash.vx ~= 0 or charact.ability.dash.vy ~= 0) then
        local tmpMovePX = charact.px + charact.ability.dash.vx * 60 * dt
        local tmpMovePY = charact.py + charact.ability.dash.vy * 60 * dt

        -- Check to avoid having a dash on a collision
        if (myLevel.CheckCollision(tmpMovePX, tmpMovePY, charact)) then
            charact.px = tmpMovePX
            charact.py = tmpMovePY
        end
        
        -- Reduce the velocity of the dash 
        if (charact.ability.dash.vx < 0 or charact.ability.dash.vy < 0) then
            charact.ability.dash.vx = charact.ability.dash.vx + (charact.weapon.ability.rarity[charact.weaponRarityIndex].velocity / 2) * 60 * dt
            charact.ability.dash.vy = charact.ability.dash.vy + (charact.weapon.ability.rarity[charact.weaponRarityIndex].velocity / 2) * 60 * dt

            if (charact.ability.dash.vx >= 0) then
                charact.ability.dash.vx = 0
            end
            if (charact.ability.dash.vy >= 0) then
                charact.ability.dash.vy = 0
            end

        elseif (charact.ability.dash.vx > 0 or charact.ability.dash.vy > 0) then
            charact.ability.dash.vx = charact.ability.dash.vx - (charact.weapon.ability.rarity[charact.weaponRarityIndex].velocity / 2) * 60 * dt
            charact.ability.dash.vy = charact.ability.dash.vy - (charact.weapon.ability.rarity[charact.weaponRarityIndex].velocity / 2) * 60 * dt

            if (charact.ability.dash.vx <= 0) then
                charact.ability.dash.vx = 0
            end
            if (charact.ability.dash.vy <= 0) then
                charact.ability.dash.vy = 0
            end
        end

        myAudio.playSound(myAudio.dash)

        -- Create the trail of the dash
        for i = 1, 10 do
            local newtrail = {}

            local localCos = math.cos(charact.angle)
            local localSin = math.sin(charact.angle)

            newtrail.px = charact.px - (love.math.random(-10, 10)  * localSin )
            newtrail.py = charact.py  - (love.math.random(-10, 10) * localCos )
            
            newtrail.width = 2 - (localCos * 20)
            newtrail.height = 2 - (localSin * 20)

            newtrail.timerLife = 0
            newtrail.lifeTrail = 0.2
            newtrail.color = {
                r = 0.15,
                g = 0.15,
                b = 0.15,
                a = 1
            }
            table.insert(charact.ability.dash.trail, newtrail)
        end
    end

    -- Update the trail to change the color and the opacity before fadding it
    if (#charact.ability.dash.trail > 0) then
        for i = #charact.ability.dash.trail, 1 , -1 do 
            local localTrail = charact.ability.dash.trail[i]

            localTrail.timerLife = localTrail.timerLife + dt

            if (localTrail.color.r < 0.5) then
                localTrail.color.r = localTrail.color.r + dt
                localTrail.color.g = localTrail.color.g + dt
                localTrail.color.b = localTrail.color.b + dt
                localTrail.color.a = localTrail.color.a - dt
            end
            
            if (localTrail.timerLife > localTrail.lifeTrail) then
                table.remove(charact.ability.dash.trail, i)
            end
            
        end 
    end

end

-- Function that manage the Dummies and his power
local function AbilityDummies(dt)
    if (#charact.ability.totem > 0) then
        local totem = charact.ability.totem[1]

        totem.lifeTimer = totem.lifeTimer + dt

        if (totem.mercyBool) then
            totem.mercyTimer = totem.mercyTimer + dt
    
            if (totem.mercyTimer >= 1) then
                totem.mercyBool = false
                totem.mercyTimer = 0
                totem.state = myState.IDLE
            end
        end

        UpdateTotemImage(totem, dt)

        if (totem.hp <= 0 or totem.lifeTimer > totem.lifeDelay or totem.room ~= generalMethod.currentRoom) then
            table.remove(charact.ability.totem, 1)
        end
    end
end

-- Function that manage the Dummies LifeBar
local function DrawLifeBar(totem)
    local lifeBarHeight = 7.5
    local lifeBarWidthFull = generalMethod.TILE_WIDTH
    local lifeBarWidthCurrentHP = (totem.hp * lifeBarWidthFull) / totem.hpMax

    local lifeBarPX, lifeBarPY

    local healthbarSprite, healthbarFrame

    lifeBarPX = totem.px - (lifeBarWidthFull / 2)
    lifeBarPY = totem.py - generalMethod.TILE_HEIGHT

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle("fill", lifeBarPX, lifeBarPY, lifeBarWidthCurrentHP, lifeBarHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", lifeBarPX, lifeBarPY, lifeBarWidthFull, lifeBarHeight)
end

-------------------------------------------------------------------------------------------

-------------- LOCAL FUNCTION LINKED TO THE BEHAVIOR OF THE CHARACTER  --------------------

-- Function to update the state of the Charact to display the WALK animation when moving it
local function UpdateStateWALK()
    charact.etat = myState.WALK
    timeSinceLastInput = 0
end

-- Function that manage the creation of the Bullets from the Character to the nearest Enemy
local function Attack(dt, myEnemies)
    -- Condition to avoid to add the deltatime on the TimerAttack when it's not needed
    if (charact.canATK == false) then
        charact.timerAttack = charact.timerAttack + dt
    end

    if (love.keyboard.isDown(mySettings.command.primary.ATTACK)) then
        if
            (#myEnemies[generalMethod.currentRoom] > 0) and
                ((charact.timerAttack > charact.weapon.rarity[charact.weaponRarityIndex].cooldown * charact.bonusCd) or (charact.canATK))
         then
            local closestEnemie = love.graphics.getWidth()
            local indexClosestEnemies = 0

            for i = 1, #myEnemies[generalMethod.currentRoom] do
                local dist =
                    generalMethod.dist(
                    charact.px,
                    charact.py,
                    myEnemies[generalMethod.currentRoom][i].px,
                    myEnemies[generalMethod.currentRoom][i].py
                )
                if (dist < closestEnemie) then
                    closestEnemie = dist
                    indexClosestEnemies = i
                end
            end

            if (charact.weapon.type == myArmory.typeWeapon.MAGIC) then
                myAudio.playSound(myAudio.wand)
            end

            myBullets.CreateBullets(charact, myEnemies[generalMethod.currentRoom][indexClosestEnemies], myEnemies)
            charact.timerAttack = 0
            charact.canATK = false
        end
    end

    if (charact.timerAttack > charact.weapon.rarity[charact.weaponRarityIndex].cooldown * charact.bonusCd) then
        charact.canATK = true
    end
end

-- Function that manage the trigger of the Ability when the Character press the button
local function Ability(dt, myLevel)
    
    -- Trigger the Ability
    if (charact.weapon.ability ~= nil) then
        if (charact.canABL == false) then
            charact.timerAbility = charact.timerAbility + dt
        end

        if (love.keyboard.isDown(mySettings.command.primary.ABILITY)) then
            if((charact.timerAbility > charact.weapon.ability.rarity[charact.weaponRarityIndex].cooldown) or (charact.canABL))then
                charact.weapon.ability.useAbility(charact.weapon.ability, charact)
                charact.timerAbility = 0
                charact.canABL = false
            end
        end

        if (charact.timerAbility > charact.weapon.ability.rarity[charact.weaponRarityIndex].cooldown) then
            charact.canABL = true
        end
    end

    -- Maange the Ability when we need to update the character regarding the dt
    if (charact.ability.rage.onRage) then
        AbilityRage(dt)
    elseif (charact.weapon.ability == myAbility.DASH) then
        AbilityDash(dt, myLevel)
    elseif (charact.weapon.ability == myAbility.TOTEMTAUNT) then
        AbilityDummies(dt)
    end
end

-- Function managing the mercyFrame (the enemy can not hit it during this frame)
local function MercyFrame(dt)
    if (charact.mercyBool) then
        charact.mercyTimer = charact.mercyTimer + dt

        if (charact.mercyTimer >= 1) then
            charact.mercyBool = false
            charact.mercyTimer = 0
        end
    end
end

-- Function that Upgrade the current Weapon by 1 rarity
local function UpgradeWeapon()
    if (charact.weaponRarity == myArmory.rarity.COMMON) then
        charact.weaponRarityIndex = charact.weaponRarityIndex + 1
        charact.weaponRarity = myArmory.rarity.UNCOMMON
    elseif (charact.weaponRarity == myArmory.rarity.UNCOMMON) then
        charact.weaponRarityIndex = charact.weaponRarityIndex + 1
        charact.weaponRarity = myArmory.rarity.RARE
    end
end

-------------------------------------------------------------------------------------------

--------------------- LOCAL FUNCTION LINKED TO THE INPUT & CAMERA  -----------------------

-- Function that update the Camera position regarding the current position of the Character
local function CameraUpdate(dt, myLevel)
    local cameraMoveX = false
    local cameraMoveY = false

    local roomSizeX = myLevel[generalMethod.currentRoom].sizeX
    local roomSizeY = myLevel[generalMethod.currentRoom].sizeY

    if (roomSizeX > 1) then
        cameraMoveX = true
    else
        generalMethod.cameraX = 0
    end
    if (roomSizeY > 1) then
        cameraMoveY = true
    else
        generalMethod.cameraY = 0
    end

    if (cameraMoveX) then
        if (charact.px <= generalMethod.WORLDWIDTH / 2) then
            generalMethod.cameraX = 0
        elseif
            (charact.px > generalMethod.WORLDWIDTH / 2 and
                charact.px < ((generalMethod.WORLDWIDTH * (roomSizeX + (roomSizeX - 1))) / 2))
         then
            generalMethod.cameraX = -charact.px + generalMethod.WORLDWIDTH / 2
        elseif (charact.px >= ((generalMethod.WORLDWIDTH * (roomSizeX + (roomSizeX - 1))) / 2)) then
            generalMethod.cameraX = -(generalMethod.WORLDWIDTH * (roomSizeX - 1))
        end
    end

    if (cameraMoveY) then
        if (charact.py <= generalMethod.WORLDHEIGHT / 2) then
            generalMethod.cameraY = 0
        elseif
            (charact.py > generalMethod.WORLDHEIGHT / 2 and
                charact.py < ((generalMethod.WORLDHEIGHT * (roomSizeY + (roomSizeY - 1))) / 2))
         then
            generalMethod.cameraY = -charact.py + generalMethod.WORLDHEIGHT / 2
        elseif (charact.py >= ((generalMethod.WORLDHEIGHT * (roomSizeY + (roomSizeY - 1))) / 2)) then
            generalMethod.cameraY = -(generalMethod.WORLDHEIGHT * (roomSizeY - 1))
        end
    end
end

-- Update the position of the character regarding the angle of the character
local function UpdateDeplacement(dt, myLevel)
    local tmpMovePX = charact.px + math.cos(charact.angle) * charact.speed * charact.bonusSpeed * 60 * dt
    local tmpMovePY = charact.py + math.sin(charact.angle) * charact.speed * charact.bonusSpeed * 60 * dt
    if (myLevel.CheckCollision(tmpMovePX, tmpMovePY, charact)) then
        charact.px = tmpMovePX
        charact.py = tmpMovePY
    end
end

-- Function that manage the keyboard and the movement of the character in the space
local function MoveManager(dt, myLevel)
    if (love.keyboard.isDown(mySettings.command.primary.UP) or love.keyboard.isDown(mySettings.command.secondary.UP)) then
       charact.angle = - math.pi / 2
       charact.mvtUp = true
       UpdateDeplacement(dt, myLevel)
       UpdateStateWALK()
    end

    if (love.keyboard.isDown(mySettings.command.primary.DOWN) or love.keyboard.isDown(mySettings.command.secondary.DOWN)) then
        charact.angle = math.pi  / 2
        charact.mvtUp = false
        UpdateDeplacement(dt, myLevel)
        UpdateStateWALK()
    end

    if (love.keyboard.isDown(mySettings.command.primary.LEFT) or love.keyboard.isDown(mySettings.command.secondary.LEFT)) then
        charact.angle = math.pi
        UpdateDeplacement(dt, myLevel)
        UpdateStateWALK()
    end

    if (love.keyboard.isDown(mySettings.command.primary.RIGHT) or love.keyboard.isDown(mySettings.command.secondary.RIGHT)) then
        charact.angle = 0
        UpdateDeplacement(dt, myLevel)
        UpdateStateWALK()
    end

    if (timeSinceLastInput > delay) then
        charact.etat = myState.IDLE
        timeSinceLastInput = 0
    end
end

-- Function regarding debugging
local function DebugInput(key)
    if (key == "x") then
        if (charact.weapon ~= myArmory.BAREHANDED) then
            charact.ChangeWeapon(myArmory.BAREHANDED)
        end
    end
    if (key == "c") then
        if (charact.weapon ~= myArmory.SPEAR) then
            charact.ChangeWeapon(myArmory.SPEAR)
        end
    end
    if (key == "v") then
        if (charact.weapon ~= myArmory.CLUB) then
            charact.ChangeWeapon(myArmory.CLUB)
        end
    end
    if (key == "b") then
        if (charact.weapon ~= myArmory.WAND) then
            charact.ChangeWeapon(myArmory.WAND)
        end
    end
end

-------------------------------------------------------------------------------------------

------------------------ LOCAL FUNCTION LINKED TO THE ANIMATION  --------------------------

-- Function to update the frame regarding if the player is going up or down
local function UpdatePlayerImage(dt)
    local indexMax, indexMin
    if (charact.mvtUp == false) then
        indexMax = 4
        indexMin = 1
    else
        indexMax = 8
        indexMin = 5
        if (charact.currentIndexImage < 5) then
            charact.currentIndexImage = indexMin
        end
    end

    -- Condition to manage a transparancy when the entity has been hit
    if (charact.mercyTimer > 0 and charact.mercyTimer < 0.5) then
        charact.mercyAlpha = charact.mercyAlpha - dt
    elseif (charact.mercyTimer > 0.5) then
        charact.mercyAlpha = charact.mercyAlpha + dt
    end

    if (charact.etat == myState.IDLE) then
        charact.currentIndexImage = indexMin
    elseif (charact.etat == myState.WALK) then
        timeSinceLastChangeImage = timeSinceLastChangeImage + dt

        if (timeSinceLastChangeImage > delay) then
            charact.currentIndexImage = charact.currentIndexImage + 1
            timeSinceLastChangeImage = 0
        end

        if (charact.currentIndexImage > indexMax) then
            charact.currentIndexImage = indexMin
        end
    end
end

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function called by the LevelManager.RetrieveItem() to update the current Weapon
function charact.ChangeWeapon(newWeapon)
    if (charact.weapon ~= newWeapon) then
        charact.weapon = newWeapon
        mySpriteManager.LoadCharacterWeapon(charact)
    elseif (charact.weapon == newWeapon) then
        UpgradeWeapon()
    end
end

-- Function called by the BulletsManager   [OPTIMIZATION: CAN BE CREATED SOMEWHERE ELSE AS ENTITY MODULE BECAUSE CAN BE USE FOR ENEMY]
function charact.ReceiveDmg(dmgReceived)
    if (not charact.mercyBool) then
        if (charact.shield == 0) then
            charact.hp = charact.hp - dmgReceived
            myAudio.playSound(myAudio.hit)
        else
            charact.shield = charact.shield - 1
        end
        charact.mercyBool = true
    end
    if (sceneState.DEBUGGERMODE == true) then
        print(
            "[CharacterManager] Player received this dmg " ..
                tostring(dmgReceived) .. " and has now hp:" .. tostring(charact.hp)
        )
    end
end

-- Function called by GameManager to Initialize Character
function charact.InitCharacter()
    CharactCreation()
    mySpriteManager.LoadCharacterWeapon(charact)
end

-- Function called by GameManager to reset the Character object
function charact.ResetCharacter()
    charact = {}
end

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY GAMEMANAGER -----------------------------------

-- Function called by the GameManager Update
function charact.UpdateCharact(dt, myEnemies, myLevel)
    if (charact.hp > 0) then
        timeSinceLastInput = timeSinceLastInput + dt

        MoveManager(dt, myLevel)

        CameraUpdate(dt, myLevel)

        Attack(dt, myEnemies)

        Ability(dt, myLevel)

        MercyFrame(dt)
    elseif (charact.hp <= 0) then
        myAudio.playSound(myAudio.death)
        sceneState.currentState = sceneState.GAMEOVER
    end

    UpdatePlayerImage(dt)
end

-- Function called by the GameManager Draw
function charact.DrawCharacter()
    local frameQuad = mySpriteManager.charact.frame[charact.currentIndexImage]


    if (charact.ability.rage.onRage) then
        -- Change the color to "Red" when the rage ability is triggered
        love.graphics.setColor(0.55,0.06,0.02, charact.mercyAlpha)
    else
        love.graphics.setColor(1, 1, 1, charact.mercyAlpha)
    end

    -- Draw the line for the Dash    
    if (charact.weapon.ability == myAbility.DASH) then
        if (#charact.ability.dash.trail > 0) then
            for i = 1, #charact.ability.dash.trail do
                love.graphics.setColor(charact.ability.dash.trail[i].color.r, charact.ability.dash.trail[i].color.g, charact.ability.dash.trail[i].color.b, charact.ability.dash.trail[i].color.a)
                love.graphics.rectangle("fill", charact.ability.dash.trail[i].px, charact.ability.dash.trail[i].py, charact.ability.dash.trail[i].width, charact.ability.dash.trail[i].height)
            end
            love.graphics.setColor(1,1,1,1)
        end
    elseif (charact.weapon.ability == myAbility.TOTEMTAUNT) then
        if (#charact.ability.totem > 0) then
            local totem = charact.ability.totem[1]
            love.graphics.draw(
                mySpriteManager.charact.ability.totem.TileSheet,
                mySpriteManager.charact.ability.totem.frame[totem.currentFrame], 
                totem.px, 
                totem.py,
                0,
                1,
                1,
                generalMethod.TILE_WIDTH / 2,
                generalMethod.TILE_HEIGHT / 2 )
            if (totem.hp < totem.hpMax) then
                DrawLifeBar(totem)
            end 
        end
    end

    love.graphics.draw(
        mySpriteManager.charact.TileSheet,
        frameQuad,
        charact.px,
        charact.py,
        0,
        1,
        1,
        generalMethod.TILE_WIDTH / 2,
        generalMethod.TILE_HEIGHT / 2
    )

    love.graphics.setColor(1, 1, 1, 1)

    if (sceneState.DEBUGGERMODE == true) then
        -- Drawing the HitBox
        -- love.graphics.setColor(0, 0, 1)
        -- love.graphics.rectangle(
        --     "line",
        --     charact.px - charact.hitBox,
        --     charact.py - charact.hitBox,
        --     charact.hitBox * 2,
        --     charact.hitBox * 2
        -- )

        -- love.graphics.setColor(1, 1, 1)
    end
end

-- Function called by the GameManager KeyPressed
function charact.KeyPressed(key, myLevel)
    if (charact.canGetItem and key == mySettings.command.primary.INTERACT) then
        myLevel.RetrieveItem(charact)
    end

    if (sceneState.DEBUGGERMODE == true) then
        DebugInput(key)
    end
end

return charact
