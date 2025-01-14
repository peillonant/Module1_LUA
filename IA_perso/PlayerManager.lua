function CreatePlayer()
    -- image
    Player.image = {}
    Player.image[1] = love.graphics.newImage("images/player_1.png")
    Player.image[2] = love.graphics.newImage("images/player_2.png")
    Player.image[3] = love.graphics.newImage("images/player_3.png")
    Player.image[4] = love.graphics.newImage("images/player_4.png")
    Player.image[5] = love.graphics.newImage("images/dead_1.png")
    Player.currentIndexImage = 1

    -- Size of the Player
    Player.height = Player.image[1]:getHeight() * 2
    Player.weight = Player.image[1]:getWidth() * 2

    -- healt
    Player.hp = 100

    -- Etat (idle, run, dead)
    Player.etat = "idle"

    -- Position & Origine
    Player.ox = Player.image[1]:getWidth()/2
    Player.oy = Player.image[1]:getHeight()/2
    Player.px = love.graphics.getWidth()/2
    Player.py = love.graphics.getHeight() - 100
    Player.speed = 4
end

local delay = 0.1
local timeSinceLastChange = 0

function UpdatePlayerImage(dt)
    if (Player.etat == "idle") then
        Player.currentIndexImage = 1
    elseif (Player.etat == "run") then
        
        timeSinceLastChange = timeSinceLastChange + dt

        if (timeSinceLastChange > delay) then
            Player.currentIndexImage = Player.currentIndexImage + 1
            timeSinceLastChange = 0
        end
        
        if (Player.currentIndexImage == 5) then
            Player.currentIndexImage = 1
        end
    elseif (Player.etat == "dead") then
        Player.currentIndexImage = 5
    end
end


function DrawPlayer()
    love.graphics.draw(Player.image[Player.currentIndexImage], Player.px, Player.py, 0, 2, 2, Player.ox, Player.oy)
end

function Bleeding()
end