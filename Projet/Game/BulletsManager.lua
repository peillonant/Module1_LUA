local generalMethod = require("GeneralMethod")
local myArmory = require("Entities/Armory")
local sceneState = require("MAE/SceneState")
local entitiesState = require("MAE/EntitiesState")
local mySpriteManager = require("Game/SpriteManager")

local bullets = {}

local enemiesList = {}

local impactBullets = {}

------------------------ LOCAL FUNCTION MANAGING THE COLLISION ----------------------------------

-- Function to check the collision between the Entity and the RANGE weapon
local function CheckBulletCollider_RANGE(localBullet, target)
    if (localBullet.typeOrigine == entitiesState.type.CHARACTER) then
        local spriteWidht = generalMethod.TILE_WIDTH / 2
        local spriteHeight = generalMethod.TILE_HEIGHT / 2

        for i = 1, #enemiesList[generalMethod.currentRoom] do
            local localEnemy = enemiesList[generalMethod.currentRoom][i]

            -- Check if the origine of the bullets is hitting the entity
            if
                (localBullet.px >= localEnemy.px - spriteWidht and localBullet.px <= localEnemy.px + spriteWidht) and
                    (localBullet.py >= localEnemy.py - spriteHeight and localBullet.py <= localEnemy.py + spriteHeight)
             then
                enemiesList.ReceiveDmg(localBullet.dmg, i)
                return true
            end

            -- Check if the whole sprite of the bullets is hitting the entity
            if
                (localBullet.px + generalMethod.TILE_WIDTH >= localEnemy.px - spriteWidht and
                    localBullet.px + generalMethod.TILE_WIDTH <= localEnemy.px - spriteWidht) and
                    (localBullet.py + generalMethod.TILE_HEIGHT >= localEnemy.py - spriteHeight and
                        localBullet.py + generalMethod.TILE_HEIGHT <= localEnemy.py - spriteHeight)
             then
                target.ReceiveDmg(localBullet.dmg, i)
                return true
            end
        end
    elseif (localBullet.typeOrigine == entitiesState.type.ENEMIE) then
        local spriteWidht = generalMethod.TILE_WIDTH / 2
        local spriteHeight = generalMethod.TILE_HEIGHT / 2

        -- Check if the origine of the bullets is hitting the entity
        if
            (localBullet.px >= target.px - spriteWidht and localBullet.px <= target.px + spriteWidht) and
                (localBullet.py >= target.py - spriteHeight and localBullet.py <= target.py + spriteHeight)
         then
            target.ReceiveDmg(localBullet.dmg, i)
            return true
        end

        -- Check if the whole sprite of the bullets is hitting the entity
        if
            (localBullet.px + generalMethod.TILE_WIDTH >= target.px - spriteWidht and
                localBullet.px + generalMethod.TILE_WIDTH <= target.px - spriteWidht) and
                (localBullet.py + generalMethod.TILE_HEIGHT >= target.py - spriteHeight and
                    localBullet.py + generalMethod.TILE_HEIGHT <= target.py - spriteHeight)
         then
            target.ReceiveDmg(localBullet.dmg, i)
            return true
        end
    end

    return false
end

-- Function to check the collision between the Entity and the CLOSE weapon
local function CheckBulletCollider_CLOSE(localBullet, target)
    if (localBullet.typeOrigine == entitiesState.type.CHARACTER) then
        -- Check the dist between the weapon (+ size of the sprite) and the enemy
        local spriteHeightWeapon = localBullet.imgTileSheetBullet:getHeight()
        for i = 1, #enemiesList[generalMethod.currentRoom] do
            local localEnemy = enemiesList[generalMethod.currentRoom][i]
            local dist = generalMethod.dist(localBullet.px, localBullet.py, localEnemy.px, localEnemy.py)

            local distToHit = localEnemy.hitBox + spriteHeightWeapon

            if (dist <= distToHit) then
                enemiesList.ReceiveDmg(localBullet.dmg, i)
            end
        end
    elseif (localBullet.typeOrigine == entitiesState.type.ENEMIE) then
        local spriteHeightWeapon = localBullet.imgTileSheetBullet:getHeight()

        local dist = generalMethod.dist(localBullet.px, localBullet.py, target.px, target.py)

        local distToHit = target.hitBox + spriteHeightWeapon

        if (dist <= distToHit) then
            target.ReceiveDmg(localBullet.dmg)
        end
    end
end

-- Function to check the collision between the Entity and the MAGIC weapon
local function CheckBulletCollider_MAGIC(localBullet, target)
    if (localBullet.typeOrigine == entitiesState.type.CHARACTER) then
        for i = 1, #enemiesList[generalMethod.currentRoom] do
            local localEnemy = enemiesList[generalMethod.currentRoom][i]
            local dist = generalMethod.dist(localBullet.px, localBullet.py, localEnemy.px, localEnemy.py)

            local distToHit = localEnemy.hitBox + localBullet.AOEEffect
            if (dist <= distToHit) then
                enemiesList.ReceiveDmg(localBullet.dmg, i)

                local localImpact = {}

                localImpact.AOEEffect = localBullet.AOEEffect
                localImpact.px = localBullet.px
                localImpact.py = localBullet.py
                localImpact.delay = 0.15
                localImpact.timeBeforeFade = 0
                                
                table.insert(impactBullets, localImpact)

            end
        end
    elseif (localBullet.typeOrigine == entitiesState.type.ENEMIE) then
        dist = generalMethod.dist(localBullet.px, localBullet.py, target.px, target.py)

        local distToHit = localEnemy.hitBox + localBullet.AOEEffect
        if (dist <= distToHit) then
            target.ReceiveDmg(localBullet.dmg)
        end
        
    end
end

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function called when we load the room
-- C'EST DEGUEULASSE, IL FAUT TROUVER UN AUTRE MOYEN POUR AVOIR ENEMYLIST CAR LE REQUIRE CREE UNE BOUCLE
function bullets.UpdateEnemiesList(list)
    enemiesList = list
end

-- Function called by the CharacterManager.Attack and by the EnemyManager.Attack
function bullets.CreateBullets(origine, target)
    local angle = generalMethod.angle(origine.px, origine.py, target.px, target.py)

    local newBullet = {}
    newBullet.typeOrigine = origine.typeEntity
    newBullet.px = origine.px
    newBullet.py = origine.py
    newBullet.directionX = math.cos(angle)
    newBullet.directionY = math.sin(angle)
    newBullet.distanceMade = 0
    newBullet.target = target

    if (newBullet.typeOrigine == entitiesState.type.CHARACTER) then
        newBullet.typeWeapon = origine.weapon.type
        newBullet.imgTileSheetBullet = origine.weapon.imgTileSheetBullet

        newBullet.speed = origine.weapon.rarity[origine.weaponRarityIndex].bulletSpeed
        newBullet.dmg = origine.weapon.rarity[origine.weaponRarityIndex].dmg + origine.bonusDMG
        newBullet.range = origine.weapon.rarity[origine.weaponRarityIndex].range

        if (newBullet.typeWeapon == myArmory.typeWeapon.MAGIC) then
            newBullet.AOEEffect = origine.weapon.rarity[origine.weaponRarityIndex].AOERange
            newBullet.targetPositionX = target.px
            newBullet.targetPositionY = target.py
        end
    else
        newBullet.typeWeapon = origine.weaponType
        newBullet.imgTileSheetBullet = origine.imgTileSheet
        newBullet.speed = origine.bulletSpeed
        newBullet.dmg = origine.dmg
        newBullet.range = origine.rangeDMG
        newBullet.indexFrameBullet = origine.indexFrame.indexBullet
    end

    -- Condition to check the type of the Weapon.
    if (newBullet.typeWeapon == myArmory.typeWeapon.CLOSE) then
        -- If it's CLOSE, we have to change the origine position to be "outside" of the Character Sprite
        -- multiply by 2/3 because the img is facing up
        newBullet.rotation = angle + math.pi * 2 / 3
        -- We had this new variable on Bullet to compute the update of the bullet to stay closed to the Entity when it's moving
        newBullet.entityOrigine = origine
    elseif (newBullet.typeWeapon == myArmory.typeWeapon.RANGE) then
        -- If it's RANGE, we have to change the rotation to put the head of the bullet toward the Entity
        newBullet.rotation = angle + math.pi / 2
    elseif (newBullet.typeWeapon == myArmory.typeWeapon.MAGIC) then
        -- If it's MAGIC
        newBullet.px = target.px
        newBullet.py = target.py - 250
        newBullet.impactPoint = target.py
    end

    -- Condition that check if the origine of the bullet it's an Enemy. Then we retrieve the index of the Enemy
    if (newBullet.typeOrigine == entitiesState.type.ENEMIE) then
        newBullet.indexEntity = origine.indexEnemy
    end

    table.insert(bullets, newBullet)

    if (sceneState.DEBUGGERMODE == true) then
        -- print(
        --     "[BulletsManager] A new bullet has been created from " ..
        --         origine.typeEntity ..
        --             " with a direction like " .. angle .. " with the weaponType " .. newBullet.typeWeapon
        -- )
    end
end

-- Function called by the GameManager Update
function bullets.UpdateBullets(dt)
    for i = #bullets, 1, -1 do
        if (bullets[i].typeWeapon == myArmory.typeWeapon.RANGE) then
            bullets[i].px = bullets[i].px + bullets[i].speed * bullets[i].directionX
            bullets[i].py = bullets[i].py + bullets[i].speed * bullets[i].directionY

            bullets[i].distanceMade = bullets[i].distanceMade + bullets[i].speed

            if (CheckBulletCollider_RANGE(bullets[i], bullets[i].target) == true) then
                table.remove(bullets, i)
            elseif (bullets[i].distanceMade >= bullets[i].range) then
                table.remove(bullets, i)
            end
        elseif (bullets[i].typeWeapon == myArmory.typeWeapon.CLOSE) then
            -- Change the position of the bullets when the Entities is moving.
            bullets[i].px = bullets[i].entityOrigine.px + (generalMethod.TILE_WIDTH / 2) * bullets[i].directionX
            bullets[i].py = bullets[i].entityOrigine.py + (generalMethod.TILE_HEIGHT / 2) * bullets[i].directionY

            -- Managing the rotation of the close weapon by using the rotation and Pi number
            bullets[i].rotation = bullets[i].rotation - math.pi * dt
            bullets[i].distanceMade = bullets[i].distanceMade + math.pi * bullets[i].speed * dt

            CheckBulletCollider_CLOSE(bullets[i], bullets[i].target)

            -- Removing the bullets at the end of the swing and not when an Entity has been hit
            if (bullets[i].distanceMade >= bullets[i].range) then
                table.remove(bullets, i)
            end
        elseif (bullets[i].typeWeapon == myArmory.typeWeapon.MAGIC) then
            bullets[i].py = bullets[i].py + bullets[i].speed

            if (bullets[i].py >= bullets[i].impactPoint) then
                CheckBulletCollider_MAGIC(bullets[i], bullets[i].target)
                table.remove(bullets, i)
            end
        end
    end

    for i = #impactBullets, 1, -1 do
        impactBullets[i].timeBeforeFade = impactBullets[i].timeBeforeFade + dt
    
        if (impactBullets[i].timeBeforeFade >= impactBullets[i].delay) then
            table.remove(impactBullets, i)
        end
    end
end

-- Function called by the GameManager Draw
function bullets.DrawBullets()
    for i = 1, #bullets do
        local frameQuad = nil
        local tileSheet = bullets[i].imgTileSheetBullet
        local ox, oy

        if (bullets[i].typeOrigine == entitiesState.type.CHARACTER) then
            frameQuad = mySpriteManager.charact.bullets.frame[2]
        elseif (bullets[i].typeOrigine == entitiesState.type.ENEMIE) then
            frameQuad =
                mySpriteManager.enemies[generalMethod.currentRoom][bullets[i].indexEntity].bullets.frame[
                bullets[i].indexFrameBullet
            ]
        end

        if (bullets[i].typeWeapon == myArmory.typeWeapon.RANGE) then
            ox = generalMethod.TILE_WIDTH / 2
            oy = generalMethod.TILE_HEIGHT / 2
        elseif
            (bullets[i].typeWeapon == myArmory.typeWeapon.CLOSE) or (bullets[i].typeWeapon == myArmory.typeWeapon.MAGIC)
         then
            ox = generalMethod.TILE_WIDTH / 2
            oy = generalMethod.TILE_HEIGHT
        end

        if (frameQuad ~= nil) then
            love.graphics.draw(tileSheet, frameQuad, bullets[i].px, bullets[i].py, bullets[i].rotation, 1, 1, ox, oy)
        end

        if (bullets[i].typeWeapon == myArmory.typeWeapon.MAGIC) then
            -- Draw the target of the bullets
            love.graphics.setColor(1, 0 , 0)
            love.graphics.circle("line", bullets[i].targetPositionX, bullets[i].targetPositionY, 5)      
            love.graphics.setColor(1,1,1)
        end
    end

    for i = 1, #impactBullets do
        love.graphics.setColor(1, 0 , 0, 0.5)
        love.graphics.circle("line", impactBullets[i].px, impactBullets[i].py, impactBullets[i].AOEEffect)

        love.graphics.setColor(1,0,0,0.25)
        love.graphics.circle("fill", impactBullets[i].px, impactBullets[i].py, impactBullets[i].AOEEffect)

        love.graphics.setColor(1,1,1,1)
    end
end

return bullets
