local zombies = {}
local player = {}
local distanceAngry = 150
local distanceBlood = 50

-- variable regarding the Zombie Movement
local timeChangeDirection = 0
local timeChangeGap = 1
local boolChangeDirection = false

-- all variable related to the zombie image
local delayImage = .075

function CreateZombie(newPlayer)
    local zombie = {}
    -- image
    zombie.image = {}
    zombie.image[1] = love.graphics.newImage("images/monster_1.png")
    zombie.image[2] = love.graphics.newImage("images/monster_2.png")
    zombie.imageAlertBlood = love.graphics.newImage("images/alertBlood.png")
    zombie.imageAlertAngry = love.graphics.newImage("images/alertAngry.png")
    zombie.timeSinceLastChangeImage = 0
    zombie.currentIndexImage = 1

    -- Size
    zombie.height = zombie.image[1]:getHeight()
    zombie.width = zombie.image[1]:getWidth()

    -- Etat (idle, searching, angry)
    zombie.etat = "idle"
    zombie.timeSpendOntheState = 0

    -- Position & Origine
    zombie.ox = zombie.image[1]:getWidth() / 2
    zombie.oy = zombie.image[1]:getHeight() / 2
    zombie.px = love.math.random(0, love.graphics.getWidth() - zombie.image[1]:getWidth())
    zombie.py = love.math.random(0, love.graphics.getHeight() / 2 - zombie.image[1]:getHeight())
    zombie.speed = .5
    zombie.directionX = Rsign()
    zombie.directionY = Rsign()

    -- Attack Value
    zombie.dmg = 5
    zombie.cdAttack = 1
    zombie.timeSinceLastAttack = 0

    -- Add the value on the local variable for this script
    player = newPlayer
    table.insert(zombies, zombie)

    return zombie
end

-- possibilité d'amelioration, les zombies peuvent pas se percuter
function UpdateZombieMovement(dt)
    for i = 1, #zombies do
        -- Zombies just walking without any purpose
        if (zombies[i].etat == "idle" or zombies[i].etat == "searching") then
            if (timeChangeDirection > timeChangeGap) then
                timeChangeDirection = 0
                boolChangeDirection = true
            end

            timeChangeDirection = timeChangeDirection + dt

            if (boolChangeDirection) then
                zombies[i].directionX = zombies[i].directionX * Rsign()
                zombies[i].directionY = zombies[i].directionY * Rsign()
                boolChangeDirection = false
            end

            -- Update the position on X
            local tmpPX = zombies[i].px + zombies[i].speed * zombies[i].directionX
            if (tmpPX > 0 and tmpPX < love.graphics.getWidth() - zombies[i].ox) then
                zombies[i].px = tmpPX
            elseif (tmpPX <= 0 or tmpPX >= love.graphics.getWidth() - zombies[i].ox) then
                zombies[i].directionX = zombies[i].directionX * -1
            end

            -- Update the position on Y
            local tmpPY = zombies[i].py + zombies[i].speed * zombies[i].directionY
            if (tmpPY > 0 and tmpPY < love.graphics.getHeight() - zombies[i].oy) then
                zombies[i].py = tmpPY
            elseif (tmpPY <= 0 or tmpPY >= love.graphics.getHeight() - zombies[i].oy) then
                zombies[i].directionY = zombies[i].directionY * -1
            end
        elseif (zombies[i].etat == "angry") then
            -- Update the position on X
            zombies[i].px =
                UpdatePositionZombieAngry(zombies[i].px, zombies[i].ox, player.px, player.ox, zombies[i].speed)

            -- Update the position on Y
            zombies[i].py =
                UpdatePositionZombieAngry(zombies[i].py, zombies[i].oy, player.py, player.oy, zombies[i].speed)
        end

        UpdateZombieImage(zombies[i], dt)
        UpdateZombieState(zombies[i], dt)
    end
end

function UpdatePositionZombieAngry(zombiePosition, zombieOrigine, playerPosition, playerOrigine, zombieSpeed)
    local distance = (zombiePosition + zombieOrigine) - (playerPosition + playerOrigine)
    if (distance > 0) then
        if (distance > zombieSpeed) then
            zombiePosition = zombiePosition - zombieSpeed
        else
            zombiePosition = zombiePosition - distance
        end
    else
        if (distance < zombieSpeed * -1) then
            zombiePosition = zombiePosition + zombieSpeed
        else
            zombiePosition = zombiePosition + distance
        end
    end

    return zombiePosition
end

function UpdateZombieState(zombie, dt)
    if (player.hp > 0) then
        local dist = Dist(zombie.px, zombie.py, player.px, player.py)
        if (zombie.etat == "idle") then
            if (dist < distanceAngry) then
                UpdateNewState(zombie, "angry")
            elseif (CheckSearchingState(zombie)) then
                UpdateNewState(zombie, "searching")
            end
        elseif (zombie.etat == "searching") then
            if (dist < distanceAngry) then
                UpdateNewState(zombie, "angry")
            else
                zombie.timeSpendOntheState = zombie.timeSpendOntheState + dt
            end

            CheckIDLEState(zombie)
        elseif (zombie.etat == "angry") then
            if (dist < distanceAngry) then
                zombie.timeSpendOntheState = 0
            else
                zombie.timeSpendOntheState = zombie.timeSpendOntheState + dt
            end
            CheckIDLEState(zombie)
        end
    else
        UpdateNewState(zombie, "idle")
    end
end

function CheckIDLEState(zombie)
    if (zombie.timeSpendOntheState > 2) then
        UpdateNewState(zombie, "idle")
    end
end

function CheckSearchingState(zombie)
    for i = 1, #player.blood do
        local dist = Dist(zombie.px, zombie.py, player.blood[i].px, player.blood[i].py)
        if (dist <= distanceBlood) then
            return true
        end
    end

    return false
end

function UpdateNewState(zombie, newState)
    zombie.etat = newState

    if (newState == "idle") then
        zombie.speed = .5
    elseif (newState == "angry") then
        zombie.speed = 1.5
    elseif (newState == "searching") then
        zombie.speed = .75
    end
end

function DrawEnemie()
    for i = 1, #zombies do
        love.graphics.draw(
            zombies[i].image[zombies[i].currentIndexImage],
            zombies[i].px,
            zombies[i].py,
            0,
            1,
            1,
            zombies[i].ox,
            zombies[i].oy
        )

        if (zombies[i].etat == "searching") then
            love.graphics.draw(
                zombies[i].imageAlertBlood,
                zombies[i].px,
                zombies[i].py - zombies[i].height / 2 - zombies[i].imageAlertBlood:getHeight() / 2,
                0,
                1,
                1,
                zombies[i].imageAlertBlood:getWidth() / 2,
                zombies[i].imageAlertBlood:getHeight() / 2
            )
        elseif (zombies[i].etat == "angry") then
            love.graphics.draw(
                zombies[i].imageAlertAngry,
                zombies[i].px,
                zombies[i].py - zombies[i].height / 2 - zombies[i].imageAlertAngry:getHeight() / 2,
                0,
                1,
                1,
                zombies[i].imageAlertAngry:getWidth() / 2,
                zombies[i].imageAlertAngry:getHeight() / 2
            )
        end
    end
end

function UpdateZombieImage(zombie, dt)
    zombie.timeSinceLastChangeImage = zombie.timeSinceLastChangeImage + dt

    if (zombie.timeSinceLastChangeImage > delayImage / zombie.speed) then
        if (zombie.currentIndexImage == 1) then
            zombie.currentIndexImage = 2
        else
            zombie.currentIndexImage = 1
        end
        zombie.timeSinceLastChangeImage = 0
    end
end
