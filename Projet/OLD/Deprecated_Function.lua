-- Function to check the collision of the Entity with border of MAP
function level.CheckCollision_old(positionX, positionY, entity)
    local localRoomSettings = level[generalMethod.currentRoom].roomSettings.layers[2]

    -- Afficher le hotspotX et le hotspotY que je calcule
    -- 4: point en haut du perso, un en dessous de ses pieds, un a gauche et un a droite

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

        if (indexFrame >= level.roomEntity.dataFrame.wall.indexMin and indexFrame <= level.roomEntity.dataFrame.wall.indexMax) then -- Hitting a wall
            return false
        elseif (indexFrame >= level.roomEntity.dataFrame.door.top.indexMin and indexFrame <= level.roomEntity.dataFrame.door.right.indexMax) then -- Hitting a door to change Room
            if (indexFrame == level.roomEntity.dataFrame.door.top.indexMin 
                or indexFrame == level.roomEntity.dataFrame.door.right.indexMin 
                or indexFrame == level.roomEntity.dataFrame.door.bottom.indexMin
                or indexFrame == level.roomEntity.dataFrame.door.left.indexMin) then
                -- Hitting close door
                return false
            else
                -- Hitting open door
                ChangeRoom(indexData, indexFrame, entity)
                return false
            end
        elseif (indexFrame == level.roomEntity.dataFrame.rockObject and entity.typeEntity == myEntity.type.CHARACTER) then
            -- Hitting an object Rock
            drawInfoItem = true
            entity.canGetItem = true
            closestItem = RetrieveClosestItem(entity)
            return false
        elseif (indexFrame >= level.roomEntity.dataFrame.endDoor.indexMin and indexFrame <= level.roomEntity.dataFrame.endDoor.indexMax) then -- Hitting the end door
            CheckEndGame()
            return false
        else
            if (entity.typeEntity == myEntity.type.CHARACTER and entity.canGetItem) then
                entity.canGetItem = false
                drawInfoItem = false
                closestItem = nil
            end

            return true
        end
    else
        print(
            "[LevelManager] WARNING -- WE HAVE AN ISSUE WITH THE COMPUTATION OF THE COLLISION FOR THE ENTITY " ..
                entity.typeEntity
        )
        return false
    end
end