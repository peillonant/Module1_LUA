local generalMethod = require("GeneralMethod")
local myBestiary = require("Entities/Bestiary")
local myState = require("MAE/EntitiesState")
local sceneState = require("MAE/SceneState")
local mySpriteManager = require("Game/SpriteManager")
local myBullets = require("Game/BulletsManager")
local myCoins = require("Game/CoinManager")

local enemies = {}

local drawDebugger = false

enemies.nbrRooms = 0

function enemies.CreateRoomEnemies(nbrRooms)
    enemies.nbrRooms = nbrRooms
    for i = 1, nbrRooms do
        enemies[i] = {}
    end
end

function enemies.CreateEnemy(indexRoom, indexEnemy, px, py, enemiesType, entity)
    local newEnemy = {}

    -- Position of the Enemie
    newEnemy.px = px
    newEnemy.py = py
    newEnemy.angle = 0

    -- Variable linked to the current state of the Charact
    newEnemy.state = myState.IDLE
    newEnemy.typeEntity = myState.type.ENEMIE

    -- Varialbe linked to the current Image
    newEnemy.currentIndexImage = 1
    newEnemy.indexEnemy = indexEnemy
    newEnemy.imgTileSheet = entity.imgTileSheet
    newEnemy.indexFrame = entity.indexFrame
    newEnemy.indexFrame.timeSinceLastChangeImage = 0
    newEnemy.indexFrame.delay = 0.1

    --  type (Normal, Elite or BOSS)
    newEnemy.type = enemiesType

    -- Multiplier settings regarding the type
    if (enemiesType == myBestiary.type.NORMAL) then
        newEnemy.multiplier = 1
        newEnemy.nbrCoin = love.math.random(0, 1)
    elseif (enemiesType == myBestiary.type.ELITE) then
        newEnemy.multiplier = 1.5
        newEnemy.nbrCoin = love.math.random(1, 4)
    elseif (enemiesType == myBestiary.type.BOSS) then
        newEnemy.multiplier = 2
    end

    -- Variable linked to the Combat
    newEnemy.hpMax = math.ceil(entity.hpMAX * newEnemy.multiplier)
    newEnemy.hp = math.ceil(entity.hpMAX * newEnemy.multiplier)
    newEnemy.hitBox = math.ceil(entity.hitBox * newEnemy.multiplier)
    newEnemy.dmg = math.ceil(entity.dmg * newEnemy.multiplier)
    newEnemy.rangeDMG = entity.rangeDMG
    newEnemy.cooldown = entity.cooldown
    newEnemy.bulletSpeed = entity.bulletSpeed
    newEnemy.timerAttack = 0
    newEnemy.canATK = true
    newEnemy.weaponType = entity.weaponType

    -- Variable linked when the entity has been hit
    newEnemy.mercyBool = false
    newEnemy.mercyTimer = 0
    newEnemy.mercyAlpha = 1

    -- Variable linked to the movement
    newEnemy.rangeSearch = entity.rangeSearch
    newEnemy.moveSpeed = entity.moveSpeed

    newEnemy.timeChangeDirection = 0
    newEnemy.timeChangeGap = love.math.random(1, 3)
    newEnemy.boolChangeDirection = false
    newEnemy.directionX = 1
    newEnemy.directionY = 1

    table.insert(enemies[indexRoom], newEnemy)
end

-- Function called by BulletsManager when a bullet has been collided
function enemies.ReceiveDmg(dmgReceived, indexEnemy)
    local localEnemy = enemies[generalMethod.currentRoom][indexEnemy]

    if (not localEnemy.mercyBool) then
        localEnemy.hp = localEnemy.hp - dmgReceived
        localEnemy.mercyBool = true
        localEnemy.state = myState.HIT
    end

    if (localEnemy.hp < 0) then
        localEnemy.hp = 0
    end

    if (sceneState.DEBUGGERMODE == true) then
        print(
            "Enemies[" ..
                tostring(indexEnemy) ..
                    "] received this dmg " .. tostring(dmgReceived) .. " and has now hp:" .. tostring(localEnemy.hp)
        )
    end
end

local function LootEnemy(localEnemy)
    if (localEnemy.type == myBestiary.type.NORMAL or localEnemy.type == myBestiary.type.ELITE) then
        myCoins.CreateCoins(localEnemy.nbrCoin, localEnemy.px, localEnemy.py)
    elseif (localEnemy.type == myBestiary.type.BOSS) then
    -- Drop a new weapon instead of coin
    end
end

-- Function managing the Attack of the Enemy entity
local function Attack(localEnemy, myCharact, dt)
    -- Condition to avoid to add the deltatime on the TimerAttack when it's not needed
    if (localEnemy.canATK == false) then
        localEnemy.timerAttack = localEnemy.timerAttack + dt
    end

    if ((localEnemy.timerAttack > localEnemy.cooldown) or (localEnemy.canATK)) then
        myBullets.CreateBullets(localEnemy, myCharact)
        localEnemy.timerAttack = 0
        localEnemy.canATK = false
    end

    if (localEnemy.timerAttack > localEnemy.cooldown) then
        localEnemy.canATK = true
    end
end

-- Function to manage the switch of the frame
local function SwitchFrame(dt, localEnemy, indexFrameStart, indexFrameEnd)
    if (localEnemy.currentIndexImage < indexFrameStart or localEnemy.currentIndexImage > indexFrameEnd) then
        localEnemy.currentIndexImage = indexFrameStart
        localEnemy.indexFrame.timeSinceLastChangeImage = 0
    else
        localEnemy.indexFrame.timeSinceLastChangeImage = localEnemy.indexFrame.timeSinceLastChangeImage + dt

        if (localEnemy.indexFrame.timeSinceLastChangeImage > localEnemy.indexFrame.delay) then
            localEnemy.currentIndexImage = localEnemy.currentIndexImage + 1
            localEnemy.indexFrame.timeSinceLastChangeImage = 0
        end

        if (localEnemy.currentIndexImage > indexFrameEnd) then
            localEnemy.currentIndexImage = indexFrameStart
        end
    end
end

-- Function to manage the switch of the frame regarding the state of the Enemy
local function UpdateEnemyImage(localEnemy, dt)
    if (localEnemy.state == myState.HIT) then
        SwitchFrame(dt, localEnemy, localEnemy.indexFrame.hitStart, localEnemy.indexFrame.hitEnd)

        -- Condition to manage a transparancy when the entity has been hit
        if (localEnemy.mercyTimer > 0 and localEnemy.mercyTimer < 0.5) then
            localEnemy.mercyAlpha = localEnemy.mercyAlpha - dt
        elseif (localEnemy.mercyTimer > 0.5) then
            localEnemy.mercyAlpha = localEnemy.mercyAlpha + dt
        end
    end

    if (localEnemy.state == myState.WALK or localEnemy.state == myState.SEARCHING) then
        SwitchFrame(dt, localEnemy, localEnemy.indexFrame.walkingStart, localEnemy.indexFrame.walkingEnd)
    end

    if (localEnemy.state == myState.ATTACK) then
        SwitchFrame(dt, localEnemy, localEnemy.indexFrame.attackStart, localEnemy.indexFrame.attackEnd)
    end
end

-- Function managing the mercyFrame (the character can not hit it during this frame)
local function MercyFrame(localEnemy, dt)
    if (localEnemy.mercyBool) then
        localEnemy.mercyTimer = localEnemy.mercyTimer + dt

        if (localEnemy.mercyTimer >= 1) then
            localEnemy.mercyBool = false
            localEnemy.mercyTimer = 0
            localEnemy.state = myState.WALK
        end
    end
end

-- Function managing the update of the State regarding the behavior of the enemy
local function UpdateEnemyState(localEnemy, myCharact, dt)
    if (localEnemy.state == myState.IDLE) then
        localEnemy.state = myState.WALK
    end

    local dist = generalMethod.dist(localEnemy.px, localEnemy.py, myCharact.px, myCharact.py)

    -- State from WALKING to SEARCHING or ATTACK
    if (localEnemy.state == myState.WALK) then
        if (dist <= localEnemy.rangeSearch) then
            localEnemy.state = myState.SEARCHING
        elseif (dist <= localEnemy.rangeDMG) then
            localEnemy.state = myState.ATTACK
        end
    end

    -- State from SEARCHING to ATTACK or WALKING
    if (localEnemy.state == myState.SEARCHING) then
        if (dist <= localEnemy.rangeDMG) then
            localEnemy.state = myState.ATTACK
        elseif (dist >= localEnemy.rangeSearch) then
            localEnemy.state = myState.WALK
        end
    end

    -- State from ATTACK to SEARCHING or WALKING
    if (localEnemy.state == myState.ATTACK) then
        if (dist >= localEnemy.rangeDMG) then
            if (dist <= localEnemy.rangeSearch) then
                localEnemy.state = myState.SEARCHING
            else
                localEnemy.state = myState.WALK
            end
        end
    end
end

-- Function managing the movement of the Enemy regarding the State
local function UpdateEnemyMovement(localEnemy, myCharact, myLevel, dt)
    -- Condition to managing the WALK state (Random direction for the Enemy updated every 2 seconds)
    if (localEnemy.state == myState.WALK) then
        if (localEnemy.timeChangeDirection > localEnemy.timeChangeGap) then
            localEnemy.timeChangeDirection = 0
            localEnemy.boolChangeDirection = true
        end

        localEnemy.timeChangeDirection = localEnemy.timeChangeDirection + dt

        if (localEnemy.boolChangeDirection) then
            localEnemy.directionX = localEnemy.directionX * generalMethod.Rsign()
            localEnemy.directionY = localEnemy.directionY * generalMethod.Rsign()
            localEnemy.boolChangeDirection = false
        end

        local tmpMoveX = localEnemy.px + localEnemy.moveSpeed * localEnemy.directionX
        local tmpMoveY = localEnemy.py + localEnemy.moveSpeed * localEnemy.directionY
        if (myLevel.CheckCollision(tmpMoveX, tmpMoveY, localEnemy)) then
            localEnemy.px = tmpMoveX
            localEnemy.py = tmpMoveY
        end
    end

    -- Condition to managing the SEARCHING state (Walking toward the Character with an approximative direction of + or - TILE_WIDHT)
    if (localEnemy.state == myState.SEARCHING) then
        local angle = generalMethod.angle(localEnemy.px, localEnemy.py, myCharact.px, myCharact.py)

        localEnemy.px = localEnemy.px + math.cos(angle) * localEnemy.moveSpeed
        localEnemy.py = localEnemy.py + math.sin(angle) * localEnemy.moveSpeed
    end

    -- Condition to managing the ATTACK state (if the enemy has a weapon close we hit directly the character. If the weapon is range we launch the bullet with approximation)
    if (localEnemy.state == myState.ATTACK) then
        if (localEnemy.dmg > 0) then
            Attack(localEnemy, myCharact, dt)
        end
    end
end

-- Function called by the GameManager Update to check when the Enemies is considered as dead
function enemies.UpdateEnemies(dt, myCharact, myLevel)
    for i = #enemies[generalMethod.currentRoom], 1, -1 do
        local localEnemy = enemies[generalMethod.currentRoom][i]

        MercyFrame(localEnemy, dt)

        UpdateEnemyState(localEnemy, myCharact, dt)

        UpdateEnemyMovement(localEnemy, myCharact, myLevel, dt)

        UpdateEnemyImage(localEnemy, dt)

        -- last check to perform because if the HP = 0 then we remove it from the List
        if (localEnemy.hp <= 0) then
            table.remove(enemies[generalMethod.currentRoom], i)
            LootEnemy(localEnemy)
        end
    end
end

local function DrawLifeBar(localEnemy)
    local lifeBarHeight = 7.5
    local lifeBarWidthFull = generalMethod.TILE_WIDTH
    local lifeBarWidthCurrentHP = (localEnemy.hp * lifeBarWidthFull) / localEnemy.hpMax

    local lifeBarPX = localEnemy.px - (lifeBarWidthFull / 2)
    local lifeBarPY = localEnemy.py - generalMethod.TILE_HEIGHT

    if (localEnemy.type == myBestiary.type.NORMAL) then
        love.graphics.setColor(1, 0, 0)
    elseif (localEnemy.type == myBestiary.type.ELITE) then
        love.graphics.setColor(1, 0.5, 0)
    end

    love.graphics.rectangle("fill", lifeBarPX, lifeBarPY, lifeBarWidthCurrentHP, lifeBarHeight)
    love.graphics.setColor(1, 1, 1)
    love.graphics.rectangle("line", lifeBarPX, lifeBarPY, lifeBarWidthFull, lifeBarHeight)
end

function enemies.DrawEnemies()
    if (#enemies[generalMethod.currentRoom] > 0) then
        for i = 1, #enemies[generalMethod.currentRoom] do
            local localEnemy = enemies[generalMethod.currentRoom][i]

            love.graphics.setColor(1, 1, 1, localEnemy.mercyAlpha)

            local frameQuad =
                mySpriteManager.enemies[generalMethod.currentRoom][localEnemy.indexEnemy].frame[
                localEnemy.currentIndexImage
            ]

            love.graphics.draw(
                mySpriteManager.enemies[generalMethod.currentRoom][localEnemy.indexEnemy].TileSheet,
                frameQuad,
                localEnemy.px,
                localEnemy.py,
                0,
                localEnemy.multiplier,
                localEnemy.multiplier,
                generalMethod.TILE_WIDTH / 2,
                generalMethod.TILE_HEIGHT / 2
            )

            -- Display life bar above the enemy
            if (localEnemy.hp < localEnemy.hpMax) then
                DrawLifeBar(localEnemy)
            end

            if (drawDebugger) then
                love.graphics.setColor(1, 1, 1, 1)

                love.graphics.print(
                    localEnemy.state,
                    localEnemy.px - generalMethod.DefaultFont:getWidth(localEnemy.state) / 2,
                    localEnemy.py - 50
                )
            end
        end
    end
end

function enemies.KeyPressed(key)
    if (sceneState.DEBUGGERMODE == true) then
        if (key == "u") then
            drawDebugger = not drawDebugger
        end
    end
end

return enemies
