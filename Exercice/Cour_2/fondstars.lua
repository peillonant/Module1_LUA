local fondstars = {}

fondstars.listeEtoile = {}

local imgEtoile = love.graphics.newImage("image/star.png")

local direction = "gauche"

function fondstars.CreeEtoile(img, x, y)
    local newEtoile = {}
    newEtoile.image = img
    newEtoile.x = x
    newEtoile.y = y
    newEtoile.vitessePulsation = love.math.random()
    newEtoile.r = 0
    newEtoile.z = .5
    newEtoile.visible = true
    newEtoile.vitesse = 1
    newEtoile.sensZoom = 1
    return newEtoile
end

function fondstars.CreeToutesLesEtoiles()
    fondstars.listeEtoile = {}
    for n = 1, 1000 do
        local rx = love.math.random(1, love.graphics.getWidth())
        local ry = love.math.random(1, love.graphics.getHeight())
        local e = fondstars.CreeEtoile(imgEtoile, rx, ry)
        table.insert(fondstars.listeEtoile, e)
    end
end

function fondstars.InverseDirection()
    for k, v in ipairs(fondstars.listeEtoile) do
        v.vitesse = -v.vitesse
    end
end

function fondstars.DeplaceEtoile(dt)
    if direction == "gauche" then
    -- si ça fait 10 secondes qui sont passés, alors direction = droite
    end

    for n = 1, #fondstars.listeEtoile do
        local etoile = fondstars.listeEtoile[n]
        -- Change le zoom
        -- if etoile.sensZoom == 1 then
        --     etoile.z = etoile.z + (etoile.sensZoom * dt)
        -- elseif etoile.sensZoom == -1 then
        --     etoile.z = etoile.z - (etoile.sensZoom * dt)
        -- end

        etoile.z = etoile.z + (etoile.sensZoom * dt * etoile.vitessePulsation)
        if etoile.z >= 1 then
            etoile.sensZoom = -1
        elseif etoile.z <= .5 then
            etoile.sensZoom = 1
        end

        -- Gère le dépassement de l'écran
        etoile.x = etoile.x + (60 * etoile.vitesse) * dt
        local largeurImg = 1 --(etoile.image:getWidth() * etoile.z) / 2
        --if etoile.vitesse > 0 then
        if etoile.x > love.graphics.getWidth() + largeurImg then
            etoile.x = etoile.x - love.graphics.getWidth()
        end
        --else
        if etoile.x < 0 - largeurImg then
            etoile.x = etoile.x + love.graphics.getWidth()
        end
        --end
    end
end

function fondstars.DrawEtoile()
    -- for index, etoile in ipairs(listeEtoile) do
    -- end
    for n = 1, #fondstars.listeEtoile do
        local etoile = fondstars.listeEtoile[n]
        -- love.graphics.draw(
        --     etoile.image,
        --     etoile.x,
        --     etoile.y,
        --     etoile.r,
        --     etoile.z,
        --     etoile.z,
        --     etoile.image:getWidth() / 2,
        --     etoile.image:getHeight() / 2
        -- )
        love.graphics.setColor(1, 1, 1, etoile.z)
        love.graphics.points(etoile.x, etoile.y)
        -- love.graphics.print(etoile.z, etoile.x, etoile.y)
        -- love.graphics.print(etoile.sensZoom, etoile.x, etoile.y + 16)
    end
end

return fondstars
