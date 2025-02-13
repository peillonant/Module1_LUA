local generalMethod = require("GeneralMethod")
local myEntity = require("MAE/EntitiesState")
local myArmory = require("Entities/Armory")
local myBonus = require("Entities/Bonus")
local myBullets = require("Game/BulletsManager")
local myEnemies = require("Game/EnemyManager")
local mySpriteManager = require("Game/SpriteManager")
local myHUDManager = require("Game/HUDManager")
local myCoins = require("Game/CoinManager")

local level = {}

local drawInfoItem = false
local closestItem

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

        if (dataLayer == 46 or dataLayer == 47) then -- Door on the Top
            table.insert(DoorPosition.Top, newDoor)
        elseif (dataLayer == 52 or dataLayer == 53) then -- Door on the Right
            table.insert(DoorPosition.Right, newDoor)
        elseif (dataLayer == 48 or dataLayer == 49) then -- Door on the Bottom
            table.insert(DoorPosition.Bottom, newDoor)
        elseif (dataLayer == 50 or dataLayer == 51) then -- Door on the Left
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

    print("ERREUR ON RetrieveIndexDoor FUNCTION")

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

    if (indexFrame == 47) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Top
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Top, indexData)
    elseif (indexFrame == 53) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Right
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Right, indexData)
    elseif (indexFrame == 49) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Bottom
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Bottom, indexData)
    elseif (indexFrame == 51) then
        doorNextRoom = level[generalMethod.currentRoom].doorNextRoom.Left
        indexDoor = RetrieveIndexDoor(level[generalMethod.currentRoom].DoorPosition.Left, indexData)
    end

    -- Second, we retrieve on which Room this door is open to
    roomToTP = doorNextRoom[indexDoor].Room
    indexDoorToTP = doorNextRoom[indexDoor].PositionDoor

    -- Third, we retrieve the index of the Frame on the dataLayer to retrieve the position of the door on the new Room
    local indexFrameNextDoor
    if (indexFrame == 47) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Bottom[indexDoorToTP].doorIndex
    elseif (indexFrame == 53) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Left[indexDoorToTP].doorIndex
    elseif (indexFrame == 49) then
        indexFrameNextDoor = level[roomToTP].DoorPosition.Top[indexDoorToTP].doorIndex
    elseif (indexFrame == 51) then
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
        col = col + 1
    elseif (col == level[roomToTP].roomSettings.width) then
        col = col - 1
    end

    if (lin < 1) then
        lin = 1
    elseif (lin == 1) then
        lin = lin + 1
    elseif (lin == level[roomToTP].roomSettings.height) then
        lin = lin - 1
    end

    generalMethod.currentRoom = roomToTP
    entity.px = col * generalMethod.TILE_WIDTH
    entity.py = lin * generalMethod.TILE_HEIGHT
end

-- Check the data layer "collider" of the room and change all doors from close to open
local function UpdateRoomData(localRoomSettings)
    localRoomSettings.updatedDoor = true

    local dataRoom = localRoomSettings.roomSettings.layers[2].data

    for i = 1, #dataRoom do
        if (dataRoom[i] == 46 or dataRoom[i] == 48 or dataRoom[i] == 50 or dataRoom[i] == 52) then
            dataRoom[i] = dataRoom[i] + 1
        end
    end
end

-- Function to retrieve the position of the rock where we will put Bonus and Weapon
local function RetrieveRockPosition(localRoom)
    local rockPosition = {}

    for index = 1, #localRoom.roomSettings.layers[2].data do
        local newRock = {}
        newRock = {col = 0, lin = 0}

        if (localRoom.roomSettings.layers[2].data[index] == 45) then
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

local function CreateTreasureRoom(localRoom)
    local bonusItem = {}
    bonusItem.type = myBonus.type.WEAPON

    -- Second, retrieve which Weapon will be display on the room
    bonusItem.weapon = myArmory.ListWeapon[love.math.random(1, 3)]

    -- Third, put the selective weapon on the position to be draw
    bonusItem.indexRocks = RetrieveRockPosition(localRoom)

    bonusItem.rockPX = bonusItem.indexRocks[1].col * generalMethod.TILE_WIDTH
    bonusItem.rockPY = bonusItem.indexRocks[1].lin * generalMethod.TILE_HEIGHT

    bonusItem.px = bonusItem.rockPX
    bonusItem.py = bonusItem.rockPY - (generalMethod.TILE_HEIGHT / 2) -- We modify the position to have the weapon above the Rock

    -- Load the Sprite for the TreasureRoom
    mySpriteManager.LoadTreasureItem(bonusItem)

    table.insert(localRoom.BonusRoom, bonusItem)
end

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

        table.insert(localRoom.BonusRoom, bonusItem)
    end
end

-- Creation of the BonusRoom
local function CreateBonusRoom(localRoom)
    localRoom.BonusRoom = {}
    if (localRoom.isTreasure) then
        CreateTreasureRoom(localRoom)
    elseif (localRoom.isShop) then
        CreateShopRoom(localRoom)
    else
        print("Not a Treasure or a Shop but still here -- WHY ? " .. localRoom)
    end
end

-- Function to update the Frame of item to have the animation
local function UpdateFrameItem(localRoom, dt)
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

local function RemoveItem(indexItem, localRoom)
    for i = #localRoom.BonusRoom, 1, -1 do
        table.remove(localRoom.BonusRoom, indexItem)
    end
end

local function RetrieveClosestItem(localRoom, myCharact)
    for i = 1, #localRoom.BonusRoom do
        local item = localRoom.BonusRoom[i]
        local dist = generalMethod.dist(item.rockPX, item.rockPY, myCharact.px, myCharact.py)

        if (dist <= generalMethod.TILE_WIDTH) then
            closestItem = item
        end
    end
end

-- Function to retrieve the item closed to the character
function level.RetrieveItem(myCharact)
    -- first check which item is the closest to the character
    local localRoom = level[generalMethod.currentRoom]
    local indexItem

    -- Condition to check the closest item to the charact when we are on the Shop
    for i = 1, #localRoom.BonusRoom do
        if (localRoom.BonusRoom[i] == closestItem) then
            indexItem = i
        end
    end

    if (closestItem.type == myBonus.type.WEAPON) then
        myCharact.ChangeWeapon(closestItem.weapon)
    elseif (closestItem.type == myBonus.type.BONUS or closestItem.type == myBonus.type.BONUS) then
        closestItem.item.useBonus(closestItem.item.buff)
    end

    RemoveItem(indexItem, localRoom)
    closestItem = nil
end

-- Function to check the collision of the Entity with border of MAP
function level.CheckCollision(positionX, positionY, entity)
    local localRoomSettings = level[generalMethod.currentRoom].roomSettings.layers[2]

    -- Afficher le hotspotX et le hotspotY que je calcule
    -- Prendre le centre du personnage et calculer entre 4 et 8 hotspots
    -- 4: point en haut du perso, un en dessous de ses pieds, un a gauche et un a droite
    -- ou parfait avec les coins
    -- Faire une fonction sur l'un des coin

    -- Voir ça avec David savoir s'il y a pas une autre méthode plus simple pour verifier les collisions
    local col, lin
    if (positionX == entity.px or positionX < entity.px) then
        col = math.floor((positionX + entity.hitBox) / generalMethod.TILE_WIDTH)
    else
        col = math.ceil((positionX + entity.hitBox) / generalMethod.TILE_WIDTH)
    end

    if (positionY == entity.py or positionY < entity.py) then
        lin = math.floor((positionY + entity.hitBox) / generalMethod.TILE_HEIGHT)
    else
        lin = math.ceil((positionY + entity.hitBox) / generalMethod.TILE_HEIGHT)
    end

    if (col >= 1 and col <= localRoomSettings.width and lin >= 1 and lin <= localRoomSettings.height) then
        local indexData = (lin - 1) * localRoomSettings.width + col
        local indexFrame = localRoomSettings.data[indexData]

        if (indexFrame >= 54 and indexFrame <= 61) then -- Hitting a wall
            return false
        elseif (indexFrame >= 46 and indexFrame <= 53) then -- Hitting a door
            if (indexFrame == 46 or indexFrame == 48 or indexFrame == 50 or indexFrame == 52) then
                -- Hitting close door
                return false
            else
                -- Hitting open door
                ChangeRoom(indexData, indexFrame, entity)
                return false
            end
        elseif (indexFrame == 45 and entity.typeEntity == myEntity.type.CHARACTER) then -- Hitting a rock
            drawInfoItem = true
            entity.canGetItem = true
            return false
        else
            if (entity.typeEntity == myEntity.type.CHARACTER and entity.canGetItem) then
                entity.canGetItem = false
                drawInfoItem = false
            end

            return true
        end
    else
        print("WARNING -- WE HAVE AN ISSUE WITH THE COMPUTATION OF THE COLLISION FOR THE ENTITY " .. entity.typeEntity)
        return false
    end
end

-- Function called by the InitGame
function level.LoadLevel()
    local rooms = require("Entities/Rooms/RoomsLVL" .. tostring(generalMethod.currentLevel))

    myEnemies.CreateRoomEnemies(rooms.nbr)
    myCoins.LinkedRoom(rooms.nbr)

    for i = 1, rooms.nbr do
        local localRoom = rooms[i]
        localRoom.roomSettings =
            require("Level/Level" .. tostring(generalMethod.currentLevel) .. "/Room" .. tostring(i))

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

function level.UpdateLevel(dt, myCharact)
    local localRoom = level[generalMethod.currentRoom]

    if (#myEnemies[generalMethod.currentRoom] == 0) then
        if (localRoom.isCleaned == false) then
            localRoom.isCleaned = true
        end

        if (localRoom.isCleaned and localRoom.updatedDoor == false) then
            UpdateRoomData(localRoom)
        end
    end

    if (drawInfoItem) then
        RetrieveClosestItem(localRoom, myCharact)
    elseif (not drawInfoItem) then
        closestItem = nil
    end

    if (localRoom.isShop) then
        UpdateFrameItem(localRoom, dt)
    end
end

function level.DrawCurrentRoom()
    local localRoomSettings = level[generalMethod.currentRoom].roomSettings

    for i = 1, #localRoomSettings.layers do
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

    if (level[generalMethod.currentRoom].isBonusRoom) then
        for i = 1, #level[generalMethod.currentRoom].BonusRoom do
            local bonusItem = level[generalMethod.currentRoom].BonusRoom[i]
            local bonusTileSheet, bonusFrame

            if (level[generalMethod.currentRoom].isTreasure) then
                bonusTileSheet = mySpriteManager.rooms.TreasureRoom.TileSheet
                bonusFrame = mySpriteManager.rooms.TreasureRoom.frame[1]
            elseif (level[generalMethod.currentRoom].isShop) then
                bonusTileSheet = bonusItem.item.sprite.TileSheet
                bonusFrame = bonusItem.item.sprite.frame[bonusItem.currentFrame]
            end

            love.graphics.draw(
                bonusTileSheet,
                bonusFrame,
                bonusItem.px,
                bonusItem.py,
                0,
                1,
                1,
                generalMethod.TILE_HEIGHT
            )

            if (closestItem ~= nil) then
                if (drawInfoItem and bonusItem == closestItem) then
                    myHUDManager.DrawInfoBullItem(bonusItem)
                end
            end
        end
    end
end

return level
