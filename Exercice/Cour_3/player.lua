local player = {}
player.img = love.graphics.newImage("images/tank.png")
player.px = 100
player.py = 100
player.ox = player.img:getWidth() / 2
player.oy = player.img:getHeight() / 2
player.r = 0

player.speed = 5

function player.Update(dt)
    if (love.keyboard.isDown("z") or love.keyboard.isDown("up")) then
        player.px = player.px + math.cos(player.r) + player.speed * dt
        player.py = player.py + math.sin(player.r)
    end
    if (love.keyboard.isDown("s") or love.keyboard.isDown("down")) then
        player.px = player.px - math.cos(player.r) + player.speed * dt
        player.py = player.py - math.sin(player.r)
    end
    if (love.keyboard.isDown("q") or love.keyboard.isDown("left")) then
        player.r = player.r - 2 * dt
    end
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
        player.r = player.r + 2 * dt
    end
end

function player.Draw()
    love.graphics.draw(player.img, player.px, player.py, player.r, 1, 1, player.ox, player.oy)

    love.graphics.setColor(1, 0, 0)
    love.graphics.circle("fill", player.px, player.py, 2)
    love.graphics.setColor(1, 1, 1)
end

return player
