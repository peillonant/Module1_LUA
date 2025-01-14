local delay = 0.1
local timeSinceLastInput = 0

function InputeManager(dt)
    timeSinceLastInput = timeSinceLastInput + dt
    
    if ((love.keyboard.isDown("z") or love.keyboard.isDown("up")) and Player.py > Player.height/2) then 
        Player.py = Player.py - (Player.speed)
        Player.etat = "run"
        timeSinceLastInput = 0
    end
        
    if ((love.keyboard.isDown("s") or love.keyboard.isDown("down")) and Player.py < (love.graphics.getHeight() - Player.height/2)) then
        Player.py = Player.py + (Player.speed)
        Player.etat = "run"
        timeSinceLastInput = 0
    end

    if ((love.keyboard.isDown("q") or love.keyboard.isDown("left")) and Player.px > Player.weight/2) then
        Player.px = Player.px - (Player.speed)
        Player.etat = "run"
        timeSinceLastInput = 0
    end

    if ((love.keyboard.isDown("d") or love.keyboard.isDown("right")) and Player.px < (love.graphics.getWidth() - Player.weight/2)) then
        Player.px = Player.px + (Player.speed)
        Player.etat = "run"
        timeSinceLastInput = 0
    end

    if (timeSinceLastInput > delay) then
        Player.etat = "idle"
        timeSinceLastInput = 0
    end
end