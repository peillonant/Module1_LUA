-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

Pong = {}
Image = love.graphics.newImage("pong.JPG")
Auto = true

function CreatePong(py, speed)
    local ping = {}
    ping.image = Image
    ping.ox = Image:getWidth()/4
    ping.oy = Image:getHeight()/4
    ping.px = 0
    ping.py = py
    ping.speed = speed
    ping.scalex = 0.5
    ping.scaley = 0.5
    return ping
end 

function love.load()
    for i = 1,10 do
        if (i == 1) then
            Pong[i] = CreatePong(love.graphics.getHeight() - Image:getHeight()/2, 3)
        
        else
            Pong[i] = CreatePong(Pong[i-1].py - Image:getHeight()/2 - 5, math.random(10))
        end
    end
end

function love.update(dt)
    if (Auto == false) then
        if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
            for i = 1,10 do
                if (Pong[i].px < love.graphics.getWidth() - Image:getWidth()/2) then
                    Pong[i].px = Pong[i].px + Pong[i].speed
                end 
                if (Pong[i].scalex < 0) then
                    Pong[i].scalex = Pong[i].scalex * -1
                end 
            end
        end

        if (love.keyboard.isDown("q") or love.keyboard.isDown("left")) then
            for i = 1,10 do
                if (Pong[i].px > Image:getWidth()/2) then
                    Pong[i].px = Pong[i].px - Pong[i].speed
                end 
                if (Pong[i].scalex > 0) then
                    Pong[i].scalex = Pong[i].scalex * -1
                end 
            end
        end
    else
        for i = 1,10 do
            if (Pong[i].scalex > 0) then -- going to the right
                if (Pong[i].px < love.graphics.getWidth() - Image:getWidth()/2) then
                    Pong[i].px = Pong[i].px + Pong[i].speed
                else
                    Pong[i].scalex = Pong[i].scalex * -1
                end
            elseif (Pong[i].scalex < 0) then -- going to the left
                if (Pong[i].px > Image:getWidth()/2) then
                    Pong[i].px = Pong[i].px - Pong[i].speed
                else
                    Pong[i].scalex = Pong[i].scalex * -1
                end
            end
        end
    end
end

function love.draw()
    for i = 1,10 do
        love.graphics.draw(Pong[i].image, Pong[i].px, Pong[i].py, 0, Pong[i].scalex, Pong[i].scaley, Pong[i].ox, Pong[i].oy)
    end
end

function love.keypressed(key)
    if (key == "up" or key == "z") then
        Auto = false
    end

    if (key == "down" or key == "s") then
        Auto = true
    end
end
