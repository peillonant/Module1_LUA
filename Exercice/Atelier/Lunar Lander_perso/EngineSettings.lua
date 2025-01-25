function CreateEngine()
    Engine.image = love.graphics.newImage("_images/engine.png")
    Engine.ox = Engine.image:getWidth()/2
    Engine.oy = Engine.image:getHeight()/2
    Engine.isOn = false
end