local player = {}

-- all variable related to the player image
local delayImage = 0.1
local timeSinceLastChangeImage = 0

-- all variable related to the player bleeding
local delayBlood = .5
local timeSinceLastChangeBlood = 0

function CreatePlayer()
    local newPlayer = {}
    -- image
    newPlayer.image = {}
    newPlayer.image[1] = love.graphics.newImage("images/player_1.png")
    newPlayer.image[2] = love.graphics.newImage("images/player_2.png")
    newPlayer.image[3] = love.graphics.newImage("images/player_3.png")
    newPlayer.image[4] = love.graphics.newImage("images/player_4.png")
    newPlayer.image[5] = love.graphics.newImage("images/dead_1.png")
    newPlayer.currentIndexImage = 1

    -- Size of the Player
    newPlayer.height = newPlayer.image[1]:getHeight()
    newPlayer.weight = newPlayer.image[1]:getWidth()

    -- healt
    newPlayer.hp = 100

    -- Bleeding
    newPlayer.blood = {}
    newPlayer.imgBlood = love.graphics.newImage("images/blood.png")
    newPlayer.isBleeding = false
    newPlayer.bleedrate = 0
    newPlayer.bloodDespawn = 5

    -- Etat (idle, run, dead)
    newPlayer.etat = "idle"

    -- Position & Origine
    newPlayer.ox = newPlayer.image[1]:getWidth() / 2
    newPlayer.oy = newPlayer.image[1]:getHeight() / 2
    newPlayer.px = love.graphics.getWidth() / 2
    newPlayer.py = love.graphics.getHeight() - 100
    newPlayer.speed = 4

    player = newPlayer

    return newPlayer
end

function UpdatePlayerImage(dt)
    if (player.etat == "idle") then
        player.currentIndexImage = 1
    elseif (player.etat == "run") then
        timeSinceLastChangeImage = timeSinceLastChangeImage + dt

        if (timeSinceLastChangeImage > delayImage) then
            player.currentIndexImage = player.currentIndexImage + 1
            timeSinceLastChangeImage = 0
        end

        if (player.currentIndexImage == 5) then
            player.currentIndexImage = 1
        end
    elseif (player.etat == "dead") then
        player.currentIndexImage = 5
    end
end

function Attacked(zombies, dt)
    if (player.hp > 0) then
        for i = 1, #zombies do
            local dist = Dist(player.px, player.py, zombies[i].px, zombies[i].py)

            if (dist < player.ox + zombies[i].ox or dist < player.oy + zombies[i].oy) then
                if (zombies[i].timeSinceLastAttack == 0) then
                    player.hp = player.hp - zombies[i].dmg
                    zombies[i].timeSinceLastAttack = zombies[i].timeSinceLastAttack + dt
                elseif (zombies[i].timeSinceLastAttack > zombies[i].cdAttack) then
                    zombies[i].timeSinceLastAttack = 0
                else
                    zombies[i].timeSinceLastAttack = zombies[i].timeSinceLastAttack + dt
                end
            else
                if (zombies[i].timeSinceLastAttack ~= 0) then
                    zombies[i].timeSinceLastAttack = 0
                end
            end
        end

        Bleeding(dt)
    else
        player.etat = "dead"
    end
end

function DrawPlayer()
    -- display the life bar above the head of the player
    HealtBar()

    love.graphics.draw(player.image[player.currentIndexImage], player.px, player.py, 0, 1, 1, player.ox, player.oy)

    --love.graphics.circle("line", player.px, player.py, 150, 150)

    if (#player.blood > 0) then
        for i = 1, #player.blood do
            love.graphics.draw(player.imgBlood, player.blood[i].px, player.blood[i].py)
        end
    end
end

function Bleeding(dt)
    if (player.hp < 100) then
        player.isBleeding = true
        player.bleedrate = 10 - math.floor(player.hp / 10)
    else
        player.isBleeding = false
        player.bleedrate = 0
    end

    if (player.isBleeding) then
        timeSinceLastChangeBlood = timeSinceLastChangeBlood + dt

        if (timeSinceLastChangeBlood > delayBlood) then
            for i = 1, player.bleedrate do
                local newBlood = {}
                newBlood.px = player.px + love.math.random(1, 10) * Rsign()
                newBlood.py = player.py + love.math.random(1, 10) * Rsign()
                newBlood.lifeTime = 0
                table.insert(player.blood, newBlood)
            end
            timeSinceLastChangeBlood = 0
        end
    end

    UpdateBleed(dt)
end

function UpdateBleed(dt)
    if (#player.blood > 0) then
        for i = #player.blood, 1, -1 do
            if (player.blood[i].lifeTime > player.bloodDespawn) then
                table.remove(player.blood, i)
            else
                player.blood[i].lifeTime = player.blood[i].lifeTime + dt
            end
        end
    end
end

function HealtBar()
    if (player.hp > 0) then
        love.graphics.push("all")

        -- Rectangle fill for the life bar
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("fill", player.px - 25, player.py - 25, player.hp / 2, 10)

        love.graphics.pop()

        -- Rectangle line to display around the life bar
        love.graphics.rectangle("line", player.px - 25, player.py - 25, 50, 10)
    end
end
