local generalMethod = require("GeneralMethod")
local myEntity = require("MAE/EntitiesState")
local mySceneState = require("MAE/SceneState")
local myArmory = require("Entities/Armory")
local myBonus = require("Entities/Bonus")
local myBullets = require("Game/BulletsManager")
local myEnemies = require("Game/EnemyManager")
local mySpriteManager = require("Game/SpriteManager")
local myHUDManager = require("Game/HUDManager")
local myCoins = require("Game/CoinManager")
local myAudio = require("Game/AudioManager")

local level = {}

local drawInfoItem = false
local closestItem
local endLevel = false
local endLevelDoor = {
    indexData = 0,
    timeSinceLastChangeImage = 0,
    delay = 0.1
}

--------------------------- LOCAL FUNCTION TO CHANGE THE ROOM AFTER PASSING A DOOR ------------------------

-- Function called on the LoadLevel to create the tab that contain the Index of all door for each room
local function GetIndexDoor(localRoom)
    local DoorPosition = {}
    DoorPosition = {
        Top = {},
        Right = {},
        Bottom = {},
        Left = {}
    }

    for i = 1, #localRoom.roomSettings.layers[2].data do
        local dataLayer = localRoom.roomSettings.layers[2].data[i]

        local newDoor = {}
        newDoor = {doorIndex = i}




        if (dataLayer >= level.roomEntity.dataFrame.door.top.indexMin and dataLayer <= level.roomEntity.dataFrame.door.top.indexMax) then -- Door on the Top
            table.insert(DoorPosition.Top, newDoor)
        elseif (dataLayer >= level.roomEntity.dataFrame.door.right.indexMin and dataLayer <= level.roomEntity.dataFrame.door.right.indexMax) then -- Door on the Right
            table.insert(DoorPosition.Right, newDoor)
        elseif (dataLayer >= level.roomEntity.dataFrame.door.bottom.indexMin and dataLayer <= level.roomEntity.dataFrame.door.bottom.indexMax) then -- Door on the Bottom
            table.insert(DoorPosition.Bottom, newDoor)
        elseif (dataLayer >= level.roomEntity.dataFrame.door.left.indexMin and dataLayer <= level.roomEntity.dataFrame.door.left.indexMax) then -- Door on the Left
            table.insert(DoorPosition.Left, newDoor)
        end
    end

    return DoorPosition
end

-- Function that manage to retrieve which index is the door on the List of the Door in the room
local function RetrieveIndexDoor(doorList, indexData)
    for i = 1, #doorList do
        if (doorList[i].doorIndex == indexData) then
            return i
        end
    end

    print("[LevelManager] ERREUR ON RetrieveIndexDoor FUNCTION")

    return 1
end

-- Function that manage the update of the current Room.
-- indexData : Index where we are on the Data tab of the Collision Layer
-- indexFrame : Value inside the Data tab of the Collision Layer
-- Entity : Entity receiving the Charact Module
local function ChangeRoom(indexData, indexFrame, entity)
    -- First, we have to retrieve which door the charact is using
    local indexDoor  -- Find the index of which door the Charact is passing by in
    local doorNextRoom  -- Find the index of the room where the charact will be send
    local roomToTP  -- Find the index of the new Room
    local indexDoorToTP  -- Find the index of the Door on the new Room

    if (indexFrame >= level.roomEntity.dataFrame.door.top.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.top.indexMax) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Top
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Top, indexData)
    elseif (indexFrame >= level.roomEntity.dataFrame.door.right.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.right.indexMax) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Right
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Right, indexData)
    elseif (indexFrame >= level.roomEntity.dataFrame.door.bottom.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.bottom.indexMax) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Bottom
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Bottom, indexData)
    elseif (indexFrame >= level.roomEntity.dataFrame.door.left.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.left.indexMax) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Left
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Left, indexData)
    end

    -- Second, we retrieve on which Room this door is open to
    roomToTP = doorNextRoom[indexDoor].Room
    indexDoorToTP = doorNextRoom[indexDoor].PositionDoor

    -- Third, we retrieve the index of the Frame on the dataLayer to retrieve the position of the door on the new Room
    local indexFrameNextDoor
    if (indexFrame >= level.roomEntity.dataFrame.door.top.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.top.indexMax) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Bottom[indexDoorToTP].doorIndex
    elseif (indexFrame >= level.roomEntity.dataFrame.door.right.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.right.indexMax) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Left[indexDoorToTP].doorIndex
    elseif (indexFrame >= level.roomEntity.dataFrame.door.bottom.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.bottom.indexMax) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Top[indexDoorToTP].doorIndex
    elseif (indexFrame >= level.roomEntity.dataFrame.door.left.indexMin + 1 and indexFrame <= level.roomEntity.dataFrame.door.left.indexMax) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Right[indexDoorToTP].doorIndex
    end

    -- Fourth, change the position of the Charact
    local lin = math.floor(indexFrameNextDoor / level[roomToTP].roomSettings.width) - 1
    local col = indexFrameNextDoor - (lin * level[roomToTP].roomSettings.width)

    if (col > level[roomToTP].roomSettings.width) then
        col = col - level[roomToTP].roomSettings.width
        lin = lin + 1
    end

    -- Modify the col and the line to be near the door on the new room and not on the door
    if (col == 1) then
        col = col + 2
    elseif (col == level[roomToTP].roomSettings.width) then
        col = col - 2
    end

    if (lin < 1) then
        lin = 2
    elseif (lin == 1) then
        lin = lin + 2
    elseif (lin >= level[roomToTP].roomSettings.height - 1) then
        lin = lin - 2
    end

    generalMethod.currentRoom = roomToTP
    entity.px = col * generalMethod.TILE_WIDTH
    entity.py = lin * generalMethod.TILE_HEIGHT
end

-- Function to check if the door we entering send us to the next Level or trigger the Win scene
local function CheckEndGame()

    myAudio.playSound(myAudio.endDoor)

    if (generalMethod.currentLevel == generalMethod.maxLevel) then
        -- We are at the end of the run so we trigger the WIN scene
        mySceneState.currentState = mySceneState.WIN
    else
        -- Now create the function to launch the next level and the load of every thing
        generalMethod.currentLevel = generalMethod.currentLevel + 1
    end
end

-----------------------------------------------------------------------------------------------------------

--------------------------- LOCAL FUNCTION LINKED TO BONUS ROOM -------------------------------------------

-- Function to retrieve the position of the rock where we will put Bonus and Weapon
local function RetrieveRockPosition(localRoom)
    local rockPosition = {}

    for index = 1, #localRoom.roomSettings.layers[2].data do
        local newRock = {}
        newRock = {col = 0, lin = 0}

        if (localRoom.roomSettings.layers[2].data[index] == level.roomEntity.dataFrame.rockObject) then
            local lin = math.floor(index / localRoom.roomSettings.width) - 1
            local col = index - (lin * localRoom.roomSettings.width)

            if (col > localRoom.roomSettings.width) then
                newRock.col = col - localRoom.roomSettings.width
                newRock.lin = lin + 1
            end

            table.insert(rockPosition, newRock)
        end
    end

    return rockPosition
end

-- Used to retrieve the weapon that will be display on the rock for the character and the position of it [called by TreasureRoom and TreasureBoos]
local function SelectWeapon(localRoom, bonusItem)
    bonusItem.type = myBonus.type.WEAPON

    -- Second, retrieve which Weapon will be display on the room
    bonusItem.weapon = myArmory.ListWeapon[love.math.random(1, 3)]

    -- Third, put the selective weapon on the position to be draw
    bonusItem.indexRocks = RetrieveRockPosition(localRoom)

    bonusItem.rockPX = bonusItem.indexRocks[1].col * generalMethod.TILE_WIDTH
    bonusItem.rockPY = bonusItem.indexRocks[1].lin * generalMethod.TILE_HEIGHT

    bonusItem.px = bonusItem.rockPX
    bonusItem.py = bonusItem.rockPY - (generalMethod.TILE_HEIGHT / 2) -- We modify the position to have the weapon above the Rock
end

-- Function to create the Treasure Room that contain one Weapon Item
local function CreateTreasureRoom(localRoom)
    local bonusItem = {}

    SelectWeapon(localRoom, bonusItem)

    -- Load the Sprite for the TreasureRoom
    mySpriteManager.LoadTreasureItem(bonusItem)

    table.insert(localRoom.BonusRoom, bonusItem)
end

-- Function to create the Shop Room that contain several Bonus Item
local function CreateShopRoom(localRoom)
    -- Retrieve all rocks that will support a bonus item
    local rocks = RetrieveRockPosition(localRoom)

    -- Now for each rock retrieve the item
    for i = 1, #rocks do
        local bonusItem = {}

        if (i == 1) then
            bonusItem.type = myBonus.type.POTION
            bonusItem.item = myBonus.listItem[1]
        else
            bonusItem.type = myBonus.type.BONUS
            bonusItem.item = myBonus.listItem[love.math.random(2, #myBonus.listItem)]
        end

        -- now, put the selective item on the position to be draw
        bonusItem.rockPX = rocks[i].col * generalMethod.TILE_WIDTH
        bonusItem.rockPY = rocks[i].lin * generalMethod.TILE_HEIGHT

        bonusItem.px = bonusItem.rockPX
        bonusItem.py = bonusItem.rockPY - (generalMethod.TILE_HEIGHT / 2) -- We modify the position to have the item above the Rock

        -- Create variable linked to the animation
        bonusItem.currentFrame = 1
        bonusItem.timeSinceLastChangeImage = 0
        bonusItem.delay = 0.1

        -- Create variable regarding the price of the object
        bonusItem.price = love.math.random(1, 8) -- Optimisation we can add a condition regarding the type of the object to increase the price

        table.insert(localRoom.BonusRoom, bonusItem)
    end
end

-- Creation of the BonusRoom (Trigger either the TreasureRoom or the ShopRoom)
local function CreateBonusRoom(localRoom)
    localRoom.BonusRoom = {}
    if (localRoom.isTreasure) then
        CreateTreasureRoom(localRoom)
    elseif (localRoom.isShop) then
        CreateShopRoom(localRoom)
    else
        print("[LevelManager] Not a Treasure or a Shop but still here -- WHY ? " .. localRoom)
    end
end

-- Function to Get the Closest Item to the Charact
local function RetrieveClosestItem(myCharact)
    if (level[generalMethod.currentRoom].BonusRoom ~= nil) then
        for i = 1, #level[generalMethod.currentRoom].BonusRoom do
            local item = level[generalMethod.currentRoom].BonusRoom[i]
            local dist = generalMethod.dist(item.px, item.py, myCharact.px, myCharact.py)

            if (dist <= generalMethod.TILE_WIDTH * generalMethod.DEFAULTSCALE) then
                return item
            end
        end
        return nil
    else
        return nil
    end
end

-----------------------------------------------------------------------------------------------------------

-------------------------- LOCAL FUNCTION LINKED TO UPDATE THE ROOM ------------------------------------

-- Function to initialize the room with the default tileMap
local function InitializeRoomCollisionLayer(localRoomSettings)
    local dataRoom = localRoomSettings.layers[2].data
    local dataRoomDefault = localRoomSettings.layers[3].data

    for i = 1, #dataRoom do
        dataRoom[i] = dataRoomDefault[i]
    end
end

-- Check the data layer "collider" of the room and change all doors from close to open
local function UpdateRoomDataDoor(localRoomSettings)
    localRoomSettings.updatedDoor = true

    local dataRoom = localRoomSettings.roomSettings.layers[2].data

    myAudio.playSound(myAudio.doorsOpen)

    -- To modify to change the color if the next room is a treasure one or boss
    for i = 1, #dataRoom do
        local indexRoomToCheck

        -- [Condition to be adjuste when we create room with different room closed to it]
        -- Retrieve the room linked to the door of the current room
        if (dataRoom[i] == level.roomEntity.dataFrame.door.top.indexMin) then
            indexRoomToCheck = level.roomEntity[generalMethod.currentRoom].doorNextRoom.Top[1].Room
        elseif (dataRoom[i] == level.roomEntity.dataFrame.door.right.indexMin) then
            indexRoomToCheck = level.roomEntity[generalMethod.currentRoom].doorNextRoom.Right[1].Room
        elseif (dataRoom[i] == level.roomEntity.dataFrame.door.bottom.indexMin) then
            indexRoomToCheck = level.roomEntity[generalMethod.currentRoom].doorNextRoom.Bottom[1].Room
        elseif (dataRoom[i] == level.roomEntity.dataFrame.door.left.indexMin) then
            indexRoomToCheck = level.roomEntity[generalMethod.currentRoom].doorNextRoom.Left[1].Room
        end

        -- Check if the room linked is a Boss Room, Treasure Room or Shop Room
        if (indexRoomToCheck ~= nil) then
            if (level.roomEntity[indexRoomToCheck].nbrEnemy > 0 and level.roomEntity[indexRoomToCheck].isBossRoom) then
                -- If Boss Room then + 3 [Halo RED]
                dataRoom[i] = dataRoom[i] + 3
            elseif (level.roomEntity[indexRoomToCheck].nbrEnemy == 0 and (level.roomEntity[indexRoomToCheck].isTreasure or level.roomEntity[indexRoomToCheck].isShop)) then
                -- If Treasur Room or Shop Room + 2 [Hale GOLD]
                dataRoom[i] = dataRoom[i] + 2
            else
                -- Else + 1 [Halo NORMAL]
                dataRoom[i] = dataRoom[i] + 1
            end
        end
    end
end

-- Function to update the Boss room layer to display the End Door
local function SpawnLevelDoor()
    local localRoom = level[generalMethod.currentRoom].roomSettings.layers[2]

    local indexWidth = localRoom.width / 2
    local indexHeight = localRoom.height / 3

    local indexData = (indexHeight * localRoom.width) + indexWidth

    localRoom.data[indexData] = level.roomEntity.dataFrame.endDoor.indexMin 

    endLevelDoor.indexData = indexData
end

-- Function to update the Boss room layer to display the End Door
local function SpawnTreasureBoss()
    -- First, we create the rock in the middle of the room
    local localRoom = level[generalMethod.currentRoom]
    local localRoomSettings = localRoom.roomSettings.layers[2]

    local indexWidth = localRoomSettings.width / 2
    local indexHeight = localRoomSettings.height / 2

    local indexData = (indexHeight * localRoomSettings.width) + indexWidth

    localRoomSettings.data[indexData] = level.roomEntity.dataFrame.rockObject

    -- Second, create the variables that contain the object dropped by the Boss
    localRoom.BonusRoom = {}
    local bonusItem = {}

    SelectWeapon(localRoom, bonusItem)

    -- Load the Sprite for the TreasureRoom
    mySpriteManager.LoadBossItem(bonusItem)

    table.insert(localRoom.BonusRoom, bonusItem)
end

-----------------------------------------------------------------------------------------------------------

-------------------------- LOCAL FUNCTION LINKED TO COLLIDER THE ROOM ------------------------------------

-- Function to return an int if the frame checked is linked to an collider object
local function CheckCollision(indexFrame, entity)
    if (indexFrame >= level.roomEntity.dataFrame.wall.indexMin and indexFrame <= level.roomEntity.dataFrame.wall.indexMax) then 
        -- Hitting a wall
        return 1
    elseif (indexFrame >= level.roomEntity.dataFrame.rock.indexMin and indexFrame <= level.roomEntity.dataFrame.rock.indexMax) then
        -- Hitting a decorative rock
        return 1
    elseif (indexFrame >= level.roomEntity.dataFrame.colliderObject.indexMin and indexFrame <= level.roomEntity.dataFrame.colliderObject.indexMax) then
        -- Hitting a decoration
        return 1
    elseif (indexFrame >= level.roomEntity.dataFrame.door.top.indexMin and indexFrame <= level.roomEntity.dataFrame.door.right.indexMax) then 
        -- Hitting a door to change Room
        if (indexFrame == level.roomEntity.dataFrame.door.top.indexMin 
            or indexFrame == level.roomEntity.dataFrame.door.right.indexMin 
            or indexFrame == level.roomEntity.dataFrame.door.bottom.indexMin
            or indexFrame == level.roomEntity.dataFrame.door.left.indexMin) then
            -- Hitting close door
            return 1
        else
            -- Hitting open door
            return 2
        end
    elseif (indexFrame == level.roomEntity.dataFrame.rockObject and entity.typeEntity == myEntity.type.CHARACTER) then
            -- Hitting an object Rock
            return 3
    elseif (indexFrame >= level.roomEntity.dataFrame.endDoor.indexMin and indexFrame <= level.roomEntity.dataFrame.endDoor.indexMax) then 
            -- Hitting the end door
            return 4
    else
        -- we have an issue
        return -1
    end

end


------------------------------------------------------------------------------------------------------------

-------------------------- LOCAL FUNCTION LINKED TO ANIMATION  ---------------------------------------------

-- Function to update the Frame of item to have the animation (Linked to Shop)
local function UpdateFrameItem(dt)
    for i = 1, #level[generalMethod.currentRoom].BonusRoom do
        local bonusItem = level[generalMethod.currentRoom].BonusRoom[i]

        bonusItem.timeSinceLastChangeImage = bonusItem.timeSinceLastChangeImage + dt

        if (bonusItem.timeSinceLastChangeImage > bonusItem.delay) then
            bonusItem.timeSinceLastChangeImage = 0
            bonusItem.currentFrame = bonusItem.currentFrame + 1
        end

        if (bonusItem.currentFrame > #bonusItem.item.sprite.frame) then
            bonusItem.currentFrame = 1
        end
    end
end

-- Function to update the Frame of the EndDoor
local function UpdateFrameEndDoor(dt)
    if (generalMethod.currentRoom == #level) then
        local frameData = level[generalMethod.currentRoom].roomSettings.layers[2].data

        endLevelDoor.timeSinceLastChangeImage = endLevelDoor.timeSinceLastChangeImage + dt

        if (endLevelDoor.timeSinceLastChangeImage > endLevelDoor.delay) then
            endLevelDoor.timeSinceLastChangeImage = 0
            frameData[endLevelDoor.indexData] = frameData[endLevelDoor.indexData] + 1
        end

        if (frameData[endLevelDoor.indexData] >= level.roomEntity.dataFrame.endDoor.indexMax) then
            frameData[endLevelDoor.indexData] = level.roomEntity.dataFrame.endDoor.indexMin
        end
    end
end

------------------------------------------------------------------------------------------------------------

-------------------------- LOCAL FUNCTION LINKED TO DRAW ITEM ON ROOM --------------------------------------

local function DrawItem(localRoom)
    for i = 1, #localRoom.BonusRoom do
        local bonusItem = localRoom.BonusRoom[i]
        local bonusTileSheet, bonusFrame

        if (localRoom.isTreasure) then
            bonusTileSheet = mySpriteManager.rooms.TreasureRoom.TileSheet
            bonusFrame = mySpriteManager.rooms.TreasureRoom.frame[1]
        elseif (localRoom.isShop) then
            bonusTileSheet = bonusItem.item.sprite.TileSheet
            bonusFrame = bonusItem.item.sprite.frame[bonusItem.currentFrame]
        elseif (localRoom.isBossRoom) then
            bonusTileSheet = mySpriteManager.rooms.BossRoom.TileSheet
            bonusFrame = mySpriteManager.rooms.BossRoom.frame[1]
        end

        love.graphics.draw(bonusTileSheet, bonusFrame, bonusItem.px, bonusItem.py, 0, 1, 1, generalMethod.TILE_HEIGHT)

        if (closestItem ~= nil) then
            if (drawInfoItem and bonusItem == closestItem) then
                myHUDManager.DrawInfoBullItem(closestItem)
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------

------------------- FUNCTION CALLED BY OTHER MODULE --------------------------------------------------------

-- Function to retrieve the item closed to the character
function level.RetrieveItem(myCharact)
    if (closestItem ~= nil) then
        -- first check which item is the closest to the character
        local localRoom = level[generalMethod.currentRoom]
        local indexItem
        local removeItem = false

        -- Condition to check the closest item to the charact when we are on the Shop
        for i = 1, #localRoom.BonusRoom do
            if (localRoom.BonusRoom[i] == closestItem) then
                indexItem = i
            end
        end

        if (closestItem.type == myBonus.type.WEAPON) then
            if (myCharact.weapon == myArmory.BAREHANDED) then
                myCharact.ChangeWeapon(closestItem.weapon)
                removeItem = true
            elseif (myCharact.weapon ~= closestItem.weapon) then -- Put the previous weapon on the Rock
                local tmpWeapon = myCharact.weapon
                myCharact.ChangeWeapon(closestItem.weapon)
                -- Change the weapon on the rock
                localRoom.BonusRoom[indexItem].weapon = tmpWeapon

                mySpriteManager.LoadBossItem(localRoom.BonusRoom[indexItem])
                removeItem = false
            elseif (myCharact.weapon == closestItem.weapon) then
                myCharact.ChangeWeapon(closestItem.weapon)
                removeItem = true
            end
        elseif (closestItem.type == myBonus.type.POTION or closestItem.type == myBonus.type.BONUS) then
            -- First we have to check if the charact has enought coin to buy it
            if (closestItem.price <= myCharact.nbCoin) then
                myCharact.nbCoin = myCharact.nbCoin - closestItem.price

                if (myCharact.nbCoin < 0) then
                    myCharact.nbCoin = 0
                end

                removeItem = true

                myAudio.playSound(myAudio.buy)

                -- Second, we have to use the Bonus and change the nbr of coin the charact has
                closestItem.item.useBonus(closestItem.item.buff)
                
                closestItem = nil
            else
                myHUDManager.notEnoughCoin = true
                print("[LevelManager] Not Enought Coin to buy it")
            end
        end

        if (removeItem) then
            table.remove(localRoom.BonusRoom, indexItem)
        end
    end
end

-- Function to check the collision of the Entity with border of MAP or with collider
function level.CheckCollision(positionX, positionY, entity)
    local localRoomSettings = level[generalMethod.currentRoom].roomSettings.layers[2]

    -- Afficher le hotspotX et le hotspotY que je calcule
    -- 4: point en haut du perso, un en dessous de ses pieds, un a gauche et un a droite

    -- Retrieve the current position of the entity 
    local col, lin

    col = math.floor((positionX / generalMethod.TILE_WIDTH)  + 1)
    lin = math.floor((positionY/ generalMethod.TILE_HEIGHT) + 1)
    
    local canMove = true
    local conditionCollider = 0
    local indexDataCollision
    local indexFrameCollision

    local colMin, colMax
    local linMin, linMax

    if (lin - 1 < 1) then linMin = 1 else linMin = lin - 1 end
    if (lin + 1 > localRoomSettings.height) then linMax = localRoomSettings.height else linMax = lin + 1 end
    if (col - 1 < 1) then colMin = 1 else colMin = col - 1 end
    if (col + 1 > localRoomSettings.width) then colMax = localRoomSettings.width else colMax = col + 1 end

    -- Now, check all dataframe around the col and lin of the entity
    for i = linMin, linMax do
        for j = colMin, colMax do
            -- first check if the position is an obstacle
            local indexData = (i - 1) * localRoomSettings.width + j
            local indexFrame = localRoomSettings.data[indexData]

            if (indexFrame >= 6 and indexFrame <= 57 and conditionCollider == 0) then
                -- now, we check if the current position of the entity is on an obstacle
                if (i == lin and j == col) then
                    conditionCollider = CheckCollision(indexFrame, entity)
                    indexDataCollision = indexData
                    indexFrameCollision = indexFrame
                else
                    -- now, we check if the collision is happening between the entity and tile around
                    local tilePositionX = (j - 1) * generalMethod.TILE_WIDTH + generalMethod.TILE_WIDTH / 2
                    local tilePositionY = (i - 1) * generalMethod.TILE_HEIGHT + generalMethod.TILE_HEIGHT / 2

                    if (generalMethod.CheckCollision(positionX,positionY, tilePositionX,tilePositionY )) then
                        conditionCollider = CheckCollision(indexFrame, entity)
                        indexDataCollision = indexData
                        indexFrameCollision = indexFrame
                    end
                end
            end 
        end
    end        

    if (conditionCollider < 0) then
            print("[LevelManager] We have an issue with the collider check")
    elseif (conditionCollider == 1) then
        -- print("[LevelManager] We hit an obstacle that trigger nothing")
        canMove = false
    elseif (conditionCollider == 2) then
        -- print("[LevelManager] We hit an openDoor")
        canMove = false
        ChangeRoom(indexDataCollision, indexFrameCollision, entity)
    elseif (conditionCollider == 3) then
        -- print("[LevelManager] We hit an object rock")
        drawInfoItem = true
        entity.canGetItem = true
        closestItem = RetrieveClosestItem(entity)
        canMove = false
    elseif (conditionCollider == 4) then
        -- print("[LevelManager] We hit the endDoor")
        CheckEndGame()
        canMove = false
    else
        if (entity.typeEntity == myEntity.type.CHARACTER and entity.canGetItem) then
            entity.canGetItem = false
            drawInfoItem = false
            closestItem = nil
        end

        canMove = true
    end

    return canMove
end


-- Function called by EnemyManager when the Boss is dead
function level.EndLevel()
    -- First, spawn the End Level Door
    SpawnLevelDoor()

    -- Second, we update the local variable to trigger the animation of the door
    endLevel = true

    -- Third, spawn a Rock and an item above it
    SpawnTreasureBoss()
end

--------------------------------------------------------------------------------------------------------

------------------- FUNCTION CALLED BY THE GAME MANAGER / MAIN -----------------------------------------

-- Function called by the InitGame
function level.LoadLevel()
    if (#level > 0) then
        for i = #level, 1, -1 do
            if (level[i].BonusRoom ~= nil) then
                level[i].BonusRoom = {}
            end
            table.remove(level, i)
        end
        endLevel = false
    end
    
    local rooms = require("Entities/Rooms/RoomsLVL" .. tostring(generalMethod.currentLevel))

    level.roomEntity = rooms

    myEnemies.CreateRoomEnemies(rooms.nbr)
    myCoins.LinkedRoom(rooms.nbr)

    for i = 1, rooms.nbr do
        local localRoom = rooms[i]
        localRoom.roomSettings =
            require("Level/Level" .. tostring(generalMethod.currentLevel) .. "/Room" .. tostring(i))

        InitializeRoomCollisionLayer(localRoom.roomSettings)

        -- Add the variable isCleaned to know when the room is open or not
        if (localRoom.nbrEnemy == 0) then
            localRoom.isCleaned = true
            localRoom.updatedDoor = true
            localRoom.isBonusRoom = true
            CreateBonusRoom(localRoom)
        else
            localRoom.isCleaned = false
            localRoom.updatedDoor = false
            localRoom.isBonusRoom = false

            -- Add Enemies in the table
            for j = 1, localRoom.nbrEnemy do
                local enemyRoom = localRoom.enemyList[j]
                local enemyPosition = localRoom.positionEnemy[j]
                local enemyType = localRoom.enemyType[j]
                myEnemies.CreateEnemy(i, j, enemyPosition.px, enemyPosition.py, enemyType, enemyRoom)
            end
        end

        -- Retrieve the Position of all doors in the room
        localRoom.DoorPosition = GetIndexDoor(localRoom)

        -- Create the table level with all rooms from the Entity
        table.insert(level, localRoom)
    end
    myBullets.UpdateEnemiesList(myEnemies)
end

function level.UpdateLevel(dt)
    local localRoom = level[generalMethod.currentRoom]

    if (#myEnemies[generalMethod.currentRoom] == 0) then
        if (localRoom.isCleaned == false) then
            localRoom.isCleaned = true
        end

        if (localRoom.isCleaned and localRoom.updatedDoor == false) then
            UpdateRoomDataDoor(localRoom)
        end
    end

    if (localRoom.isShop) then
        UpdateFrameItem(dt)
    end

    if (endLevel) then
        UpdateFrameEndDoor(dt)
    end
end

function level.DrawCurrentRoom()
    local localRoomSettings = level[generalMethod.currentRoom].roomSettings

    for i = 1, 2 do
        local layer = localRoomSettings.layers[i]
        local indexTile = 1
        for lin = 1, layer.height do
            for col = 1, layer.width do
                local localFrame = layer.data[indexTile]
                if localFrame ~= 0 then
                    love.graphics.draw(
                        mySpriteManager.rooms.TileSheet,
                        mySpriteManager.rooms.frame[localFrame],
                        (col - 1) * generalMethod.TILE_WIDTH,
                        (lin - 1) * generalMethod.TILE_HEIGHT
                    )
                end
                indexTile = indexTile + 1
            end
        end
    end

    local localRoom = level[generalMethod.currentRoom]

    if (localRoom.isBonusRoom) then
        DrawItem(localRoom)
    elseif (localRoom.isBossRoom and localRoom.BonusRoom) then
        DrawItem(localRoom)
    end
end

return level
