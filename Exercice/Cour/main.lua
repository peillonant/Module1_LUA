-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local star = {}
star.img = love.graphics.newImage("image/star.png")
star.type = nil

local pause = true
local reverse = false
local NBRSTAR = 20

function Rsign()
    return love.math.random(2) == 2 and 1 or -1
end

function CreateStar()
    local newEtoile = {}
    newEtoile.px = love.math.random(star.img:getWidth() / 2, love.graphics.getWidth() - star.img:getWidth() / 2)
    newEtoile.py = love.math.random(star.img:getHeight() / 2, love.graphics.getHeight() - star.img:getHeight() / 2)
    newEtoile.rotation = 0
    newEtoile.scale = love.math.random(1, 5) / 10
    newEtoile.scaleMax = .5
    newEtoile.scaleMin = .1
    newEtoile.speedPulse = 0.5
    newEtoile.ox = star.img:getWidth() / 2
    newEtoile.oy = star.img:getHeight() / 2
    newEtoile.speed = love.math.random(1, 2)
    newEtoile.directionX = 1 * Rsign()
    newEtoile.directionY = 1 * Rsign()
    zoom = true
    return newEtoile
end

function CreateShootingStar()
    local newEtoile = {}
    local px, dirX
    if (reverse == false) then
        px = love.math.random(0, love.graphics.getWidth() / 2 - star.img:getWidth() / 2)

        dirX = 1
    elseif (reverse) then
        px = love.math.random(love.graphics.getWidth() / 2 - star.img:getWidth() / 2, love.graphics.getWidth())
        dirX = -1
    end

    newEtoile.px = px
    newEtoile.py = love.math.random(0, love.graphics.getHeight() / 2 - star.img:getHeight() / 2)
    newEtoile.directionX = dirX
    newEtoile.directionY = 1

    newEtoile.rotation = 0
    newEtoile.scale = 0.1
    newEtoile.scaleMax = 0.12
    newEtoile.scaleMin = 0.05
    newEtoile.speedPulse = love.math.random(5, 10) / 100
    newEtoile.ox = star.img:getWidth() / 2
    newEtoile.oy = star.img:getHeight() / 2
    newEtoile.speed = love.math.random(1, 5)

    newEtoile.trail = {}
    return newEtoile
end

function Rotation(starLocal, dt)
    starLocal.rotation = starLocal.rotation + dt
end

function Pulsation(starLocal, dt)
    if (starLocal.scale >= starLocal.scaleMax) then
        starLocal.speedPulse = starLocal.speedPulse * -1
    elseif (starLocal.scale <= starLocal.scaleMin) then
        starLocal.speedPulse = starLocal.speedPulse * -1
    end

    starLocal.scale = starLocal.scale + dt * starLocal.speedPulse
end

function RemoveStar(starLocal)
    for i = #star, 1, -1 do
        if (star[i] == starLocal) then
            table.remove(star, i)
            return
        end
    end
end

function Movement(starLocal)
    if (star.type == "classic") then
        if
            (starLocal.px + starLocal.speed * starLocal.directionX >
                love.graphics.getWidth() - (star.img:getWidth() / 2) * starLocal.scale) or
                (starLocal.px + starLocal.speed * starLocal.directionX < (star.img:getWidth() / 2) * starLocal.scale)
         then
            starLocal.directionX = starLocal.directionX * -1
        end

        if
            (starLocal.py + starLocal.speed * starLocal.directionY >
                love.graphics.getHeight() - (star.img:getHeight() / 2) * starLocal.scale) or
                (starLocal.py + starLocal.speed * starLocal.directionY < (star.img:getHeight() / 2) * starLocal.scale)
         then
            starLocal.directionY = starLocal.directionY * -1
        end
    elseif (star.type == "shooting") then
        if (starLocal.px > love.graphics.getWidth()) or (starLocal.py > love.graphics.getHeight()) then
            RemoveStar(starLocal)
            table.insert(star, CreateShootingStar())
        end
        table.insert(starLocal.trail, CreateTrail(starLocal))
    end

    starLocal.px = starLocal.px + starLocal.speed * starLocal.directionX
    starLocal.py = starLocal.py + starLocal.speed
end

function CreateTrail(starLocal)
    local newtrail = {}
    newtrail.px = starLocal.px
    newtrail.py = starLocal.py
    newtrail.lifeTimeEnd = 0.5
    newtrail.lifeTimeCurrent = 0
    newtrail.scale = starLocal.scaleMin
    newtrail.alpha = 0.75
    return newtrail
end

function RemoveTrail(starLocal, dt)
    print(#starLocal.trail)

    if (#starLocal.trail) then
        for i = #starLocal.trail, 1, -1 do
            starLocal.trail[i].lifeTimeCurrent = starLocal.trail[i].lifeTimeCurrent + dt
            starLocal.trail[i].alpha = starLocal.trail[i].alpha - dt

            if (starLocal.trail[i].lifeTimeCurrent > starLocal.trail[i].lifeTimeEnd) then
                table.remove(starLocal.trail, i)
            end
        end
    end
end

function Reverse(starLocal)
    starLocal.directionX = starLocal.directionX * -1
    starLocal.directionY = starLocal.directionY * -1
end

function Reset(star)
    star.img = love.graphics.newImage("image/star.png")
    star.rotation = 0
    star.scale = 0
    star.ox = star.img:getWidth() / 2
    star.oy = star.img:getHeight() / 2
end

function ChangePosition(star)
    star.px = love.math.random(1, love.graphics.getWidth() - star.img:getWidth())
    star.py = love.math.random(1, love.graphics.getHeight() - star.img:getHeight())
end

function love.load()
    for i = 1, NBRSTAR do
        -- Create Classic Star
        -- table.insert(star, CreateStar())
        -- star.type = "classic"

        -- Create Shooting Star
        table.insert(star, CreateShootingStar())
        star.type = "shooting"
    end
end

function love.update(dt)
    if (pause) then
        for i = 1, #star do
            -- Rotation de l'ensemble des stars
            Rotation(star[i], dt)

            -- Pulsation
            Pulsation(star[i], dt)

            -- Movement
            Movement(star[i])

            -- Remove trail
            RemoveTrail(star[i], dt)
        end
    end
end

function love.draw()
    for i = 1, #star do
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            star.img,
            star[i].px,
            star[i].py,
            star[i].rotation,
            star[i].scale,
            star[i].scale,
            star[i].ox,
            star[i].oy
        )

        for j = 1, #star[i].trail do
            love.graphics.setColor(1, 1, 1, star[i].trail[j].alpha)
            love.graphics.draw(
                star.img,
                star[i].trail[j].px,
                star[i].trail[j].py,
                star[i].rotation,
                star[i].trail[j].scale,
                star[i].trail[j].scale,
                star[i].ox,
                star[i].oy
            )
        end
    end
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end

    if (key == "r") then
        for i = 1, #star do
            Reset(star[i])
        end
    end

    if (key == "space") then
        if (star.type == "classic") then
            for i = 1, #star do
                Reverse(star[i])
            end
        elseif (star.type == "shooting") then
            for i = 1, #star do
                star[i].directionX = star[i].directionX * -1
            end
            reverse = not reverse
        end
    end

    if (key == "c") then
        for i = 1, #star do
            ChangePosition(star[i])
        end
    end

    if (key == "p") then
        pause = not pause
    end
end
