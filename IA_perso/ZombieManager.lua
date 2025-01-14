function CreateZombie()
    local zombie = {}
    -- image
    zombie.image = {}
    zombie.image[1] = love.graphics.newImage("images/monster_1.png")
    zombie.image[2] = love.graphics.newImage("images/monster_2.png")
    
    Player.currentIndexImage = 1

    -- Size of the Player
    zombie.height = zombie.image[1]:getHeight() * 2
    zombie.weight = zombie.image[1]:getWidth() * 2

    -- Etat (idle, run, dead)
    zombie.etat = "idle"

    -- Position & Origine
    zombie.ox = zombie.image[1]:getWidth()/2
    zombie.oy = Player.image[1]:getHeight()/2
    zombie.px = love.graphics.getWidth()/2
    zombie.py = love.graphics.getHeight() - 100
    zombie.speed = 2

    return zombie
end
