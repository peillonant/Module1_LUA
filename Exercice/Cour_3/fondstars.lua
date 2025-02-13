local mStars = {}

-- Le contenu du module
print("Bonjour je suis le module mStars")

local direction = "gauche"
local listeEtoile = {}
mStars.nombreEtoiles = love.math.random(100, 200)

local imgEtoile = love.graphics.newImage("images/star.png")

local function CreeEtoile(img, x, y)
    local newEtoile = {}
    newEtoile.image = img
    newEtoile.x = x
    newEtoile.y = y
    newEtoile.vitessePulsation = .2 + love.math.random()
    newEtoile.r = 0
    newEtoile.z = .5
    newEtoile.visible = true
    newEtoile.vitesse = 1
    newEtoile.sensZoom = 1
    return newEtoile
end

function mStars.CreeToutesLesEtoiles()
    listeEtoile = {}
    for n = 1, mStars.nombreEtoiles do
        local rx = love.math.random(1, love.graphics.getWidth())
        local ry = love.math.random(1, love.graphics.getHeight())
        local e = CreeEtoile(imgEtoile, rx, ry)
        table.insert(listeEtoile, e)
    end
end

function mStars.deplaceEtoiles(dt)
    if direction == "gauche" then
    -- si ça fait 10 secondes qui sont passés, alors direction = droite
    end

    for n = 1, #listeEtoile do
        local etoile = listeEtoile[n]
        -- Change le zoom
        -- if etoile.sensZoom == 1 then
        --     etoile.z = etoile.z + (etoile.sensZoom * dt)
        -- elseif etoile.sensZoom == -1 then
        --     etoile.z = etoile.z - (etoile.sensZoom * dt)
        -- end

        etoile.z = etoile.z + (etoile.sensZoom * dt * etoile.vitessePulsation)
        if etoile.z >= 1 then
            etoile.sensZoom = -1
        elseif etoile.z <= .1 then
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

function mStars.dessineEtoiles()
    -- for index, etoile in ipairs(listeEtoile) do
    -- end
    for n = 1, #listeEtoile do
        local etoile = listeEtoile[n]
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
        love.graphics.circle("fill", etoile.x, etoile.y, 2)
        -- love.graphics.print(etoile.z, etoile.x, etoile.y)
        -- love.graphics.print(etoile.sensZoom, etoile.x, etoile.y + 16)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function mStars.InverseDirection()
    for k, v in ipairs(listeEtoile) do
        v.vitesse = -v.vitesse
    end
end

return mStars
