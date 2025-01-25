local delay = 0.1
local timeSinceLastInput = 0

function InputeManager(player, dt)
    timeSinceLastInput = timeSinceLastInput + dt

    if (player.hp > 0) then
        if ((love.keyboard.isDown("z") or love.keyboard.isDown("up")) and player.py > player.height / 2) then
            player.py = player.py - (player.speed)
            player.etat = "run"
            timeSinceLastInput = 0
        end

        if
            ((love.keyboard.isDown("s") or love.keyboard.isDown("down")) and
                player.py < (love.graphics.getHeight() - player.height / 2))
         then
            player.py = player.py + (player.speed)
            player.etat = "run"
            timeSinceLastInput = 0
        end

        if ((love.keyboard.isDown("q") or love.keyboard.isDown("left")) and player.px > player.weight / 2) then
            player.px = player.px - (player.speed)
            player.etat = "run"
            timeSinceLastInput = 0
        end

        if
            ((love.keyboard.isDown("d") or love.keyboard.isDown("right")) and
                player.px < (love.graphics.getWidth() - player.weight / 2))
         then
            player.px = player.px + (player.speed)
            player.etat = "run"
            timeSinceLastInput = 0
        end

        if (timeSinceLastInput > delay) then
            player.etat = "idle"
            timeSinceLastInput = 0
        end
    end
end
