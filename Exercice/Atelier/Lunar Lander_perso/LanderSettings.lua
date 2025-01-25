function CreateLander()
    Lander.image = love.graphics.newImage("_images/ship.png")
    Lander.ox = Lander.image:getWidth()/2
    Lander.oy = Lander.image:getHeight()/2
    Lander.px = love.graphics.getWidth()/2
    Lander.py = love.graphics.getHeight()/2
    Lander.angle = 270
    Lander.vx = 0
    Lander.vy = 0
    Lander.speed = 3
end