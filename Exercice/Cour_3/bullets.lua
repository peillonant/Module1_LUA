local bullets = {}

function bullets.CreateBullets(px, py, direction)
    local newBullets = {}
    newBullets.px = px
    newBullets.py = py
    newBullets.speed = 5
    newBullets.direction = direction

    table.insert(bullets, newBullets)
end

function bullets.UpdateBullets(dt)
    for i = #bullets, 1, -1 do
        local localBullets = bullets[i]

        localBullets.px = localBullets.px + math.cos(localBullets.direction) * localBullets.speed * 60 * dt
        localBullets.py = localBullets.py + math.sin(localBullets.direction) * localBullets.speed * 60 * dt

        if
            (localBullets.px <= 0 or localBullets.px >= love.graphics.getWidth() or localBullets.py <= 0 or
                localBullets.py >= love.graphics.getHeight())
         then
            table.remove(bullets, i)
        end
    end
end

function bullets.DrawBullets()
    for i = 1, #bullets do
        love.graphics.setColor(1, 0, 0)
        local localBullets = bullets[i]
        love.graphics.circle("fill", localBullets.px, localBullets.py, 5, 5)
    end
end

return bullets
