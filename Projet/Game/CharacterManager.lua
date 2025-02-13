local generalMethod = require("GeneralMethod")
local myArmory = require("Entities/Armory")
local myState = require("MAE/EntitiesState")
local sceneState = require("MAE/SceneState")
local mySpriteManager = require("Game/SpriteManager")
local myBullets = require("Game/BulletsManager")

local charact = {}

-- Variable linked to the Input for the IMG
local delay = 0.1
local timeSinceLastInput = 0
local timeSinceLastChangeImage = 0

-- Function to create the Character
local function CharactCreation()
    -- Position and Rotation of the Character
    charact.px = 200
    charact.py = 200
    charact.speed = 3
    charact.mvtUp = true

    -- Variable linked to the current state of the Charact
    charact.etat = myState.IDLE

    -- Variable linked to the "inventory"
    charact.weapon = myArmory.BAREHANDED
    charact.typeEntity = myState.type.CHARACTER
    charact.nbCoin = 0

    -- Varialbe linked to the current Image
    charact.currentIndexImage = 1

    -- Default setting
    charact.hpLimit = 20
    charact.hpMax = 10
    charact.hp = 10
    charact.shield = 0

    -- Variable Buff
    charact.bonusDMG = 0
    charact.bonusSpeed = 0

    -- Variable linked to the ATK & ABL
    charact.hitBox = generalMethod.TILE_HEIGHT / 2
    charact.timerAttack = 0
    charact.timerAbility = 0
    charact.canATK = true
    charact.canABL = true

    -- Variable linked when the entity has been hit
    charact.mercyBool = false
    charact.mercyTimer = 0
    charact.mercyAlpha = 1

    -- Variable to know when the charact can retrieve the item
    charact.canGetItem = false
end

function charact.InitCharacter()
    CharactCreation()
    mySpriteManager.LoadCharacterWeapon(charact.weapon)
end

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

-- Function to update the state of the Charact to display the Run animation when moving it
local function UpdateStateRun()
    charact.etat = myState.RUN
    timeSinceLastInput = 0
end

-- Function that manage the keyboard and the movement of the character in the space
local function InputManager(dt, myLevel)
    if (love.keyboard.isDown("z") or love.keyboard.isDown("up")) then
        local tmpMove = charact.py - charact.speed * 60 * dt
        if (myLevel.CheckCollision(charact.px, tmpMove, charact)) then
            charact.py = tmpMove
        end
        charact.mvtUp = true
        UpdateStateRun()
    end

    if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) then
        local tmpMove = charact.py + charact.speed * 60 * dt
        if (myLevel.CheckCollision(charact.px, tmpMove, charact)) then
            charact.py = tmpMove
        end
        charact.mvtUp = false
        UpdateStateRun()
    end

    if (love.keyboard.isDown("q") or love.keyboard.isDown("left")) then
        local tmpMove = charact.px - charact.speed * 60 * dt
        if (myLevel.CheckCollision(tmpMove, charact.py, charact)) then
            charact.px = tmpMove
        end
        UpdateStateRun()
    end

    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
        local tmpMove = charact.px + charact.speed * 60 * dt
        if (myLevel.CheckCollision(tmpMove, charact.py, charact)) then
            charact.px = tmpMove
        end
        UpdateStateRun()
    end

    if (timeSinceLastInput > delay) then
        charact.etat = myState.IDLE
        timeSinceLastInput = 0
    end
end

-- Function that manage the creation of the Bullets from the Character to the nearest Enemy
local function Attack(dt, myEnemies)
    -- Condition to avoid to add the deltatime on the TimerAttack when it's not needed
    if (charact.canATK == false) then
        charact.timerAttack = charact.timerAttack + dt
    end

    if (love.keyboard.isDown("space")) then
        if
            (#myEnemies[generalMethod.currentRoom] > 0) and
                ((charact.timerAttack > charact.weapon.cooldown) or (charact.canATK))
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

            myBullets.CreateBullets(charact, myEnemies[generalMethod.currentRoom][indexClosestEnemies], myEnemies)
            charact.timerAttack = 0
            charact.canATK = false
        end
    end

    if (charact.timerAttack > charact.weapon.cooldown) then
        charact.canATK = true
    end
end

function charact.ChangeWeapon(newWeapon)
    charact.weapon = newWeapon
    mySpriteManager.LoadCharacterWeapon(charact.weapon)
end

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
    elseif (charact.etat == myState.RUN) then
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

-- Function that gather every function linked to keyboard input
function charact.UpdateCharact(dt, myEnemies, myLevel)
    if (charact.hp > 0) then
        timeSinceLastInput = timeSinceLastInput + dt

        InputManager(dt, myLevel)

        CameraUpdate(dt, myLevel)

        Attack(dt, myEnemies)

        MercyFrame(dt)
    end
    UpdatePlayerImage(dt)
end

function charact.ReceiveDmg(dmgReceived)
    if (not charact.mercyBool) then
        charact.hp = charact.hp - dmgReceived
        charact.mercyBool = true
    end
    if (sceneState.DEBUGGERMODE == true) then
        print("Player received this dmg " .. tostring(dmgReceived) .. " and has now hp:" .. tostring(charact.hp))
    end
end

-- Can be optimize to a specific Module that manage the drawing of everything
function charact.DrawCharacter()
    local frameQuad = mySpriteManager.charact.frame[charact.currentIndexImage]

    love.graphics.setColor(1, 1, 1, charact.mercyAlpha)

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
        love.graphics.setColor(0, 0, 1)
        love.graphics.rectangle(
            "line",
            charact.px - charact.hitBox,
            charact.py - charact.hitBox,
            charact.hitBox * 2,
            charact.hitBox * 2
        )

        love.graphics.setColor(1, 1, 1)
    end
end

-- Function regarding debugging
local function DebugInput(key)
    if (key == "x") then
        if (charact.weapon ~= myArmory.BAREHANDED) then
            ChangeWeapon(myArmory.BAREHANDED)
        end
    end
    if (key == "c") then
        if (charact.weapon ~= myArmory.SPEAR) then
            ChangeWeapon(myArmory.SPEAR)
        end
    end
    if (key == "v") then
        if (charact.weapon ~= myArmory.CLUB) then
            ChangeWeapon(myArmory.CLUB)
        end
    end
    if (key == "b") then
        if (charact.weapon ~= myArmory.WAND) then
            ChangeWeapon(myArmory.WAND)
        end
    end
end

function charact.KeyPressed(key, myLevel)
    if (charact.canGetItem and key == "e") then
        myLevel.RetrieveItem(charact)
    end

    if (sceneState.DEBUGGERMODE == true) then
        DebugInput(key)
    end
end

return charact
