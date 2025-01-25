-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local vitesse = {
    kmph = 0,
    angle = 0
}
local regulateur = {
    kmph = 0,
    angle = 0
}
local font
local ratioVitesseAngle = 1.0656 -- vitessee to tour/min = x 3,33 & tour to angle = x 0,32 donc 3,33 x 0.32 = 1.0656
local imgFull = {
    img = love.graphics.newImage("image/compteur.png"),
    width = 498,
    height = 428
}

local compteur_Vitesse = {
    width = 430,
    height = imgFull.height
}
compteur_Vitesse.quad = love.graphics.newQuad(0, 0, compteur_Vitesse.width, compteur_Vitesse.height, imgFull.img)

local aiguille_Vitesse = {
    width = 50,
    height = 224,
    ox = 25,
    oy = 25
}
aiguille_Vitesse.quad =
    love.graphics.newQuad(
    imgFull.width - aiguille_Vitesse.width,
    63,
    aiguille_Vitesse.width,
    aiguille_Vitesse.height,
    imgFull.img
)

function love.load()
    vitesse.kmph = 50
    regulateur.kmph = 50

    fontVitesse = love.graphics.newFont(50)
    fontRegulateur = love.graphics.newFont(35)
end

function love.update(dt)
    if (vitesse.kmph ~= regulateur.kmph) then
        local dif = math.abs(vitesse.kmph - regulateur.kmph)

        if vitesse.kmph < regulateur.kmph then
            vitesse.kmph = vitesse.kmph + (dif) * dt
        elseif vitesse.kmph > regulateur.kmph then
            vitesse.kmph = vitesse.kmph - (dif) * dt
        end
        if dif < 0.05 then
            vitesse.kmph = regulateur.kmph
        end
    end

    vitesse.angle = vitesse.kmph * ratioVitesseAngle
    regulateur.angle = regulateur.kmph * ratioVitesseAngle
end

function love.draw()
    -- Compteur
    love.graphics.draw(
        imgFull.img,
        compteur_Vitesse.quad,
        love.graphics.getWidth() / 2 - compteur_Vitesse.width / 2,
        love.graphics.getHeight() / 2 - compteur_Vitesse.height / 2
    )

    love.graphics.setFont(fontVitesse)
    -- Vitesse Text
    love.graphics.print(
        math.floor(vitesse.kmph),
        love.graphics.getWidth() / 2 - fontVitesse:getWidth(math.floor(vitesse.kmph)) / 2,
        love.graphics.getHeight() / 2 + fontVitesse:getHeight(vitesse.kmph)
    )

    love.graphics.setFont(fontRegulateur)
    love.graphics.setColor(1, 0, 0)
    -- Regulateur Text
    love.graphics.print(
        regulateur.kmph,
        love.graphics.getWidth() / 2 - fontRegulateur:getWidth(regulateur.kmph) / 2,
        love.graphics.getHeight() / 2 - fontRegulateur:getHeight(regulateur.kmph) * 2
    )
    love.graphics.setColor(1, 1, 1)

    -- Aiguille Regulateur
    love.graphics.setColor(0.25, 0.25, 0.25)
    love.graphics.draw(
        imgFull.img,
        aiguille_Vitesse.quad,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        math.rad(regulateur.angle),
        1,
        1,
        aiguille_Vitesse.ox,
        aiguille_Vitesse.oy
    )
    love.graphics.setColor(1, 1, 1)

    -- Aiguille Vitesse
    love.graphics.draw(
        imgFull.img,
        aiguille_Vitesse.quad,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        math.rad(vitesse.angle),
        1,
        1,
        aiguille_Vitesse.ox,
        aiguille_Vitesse.oy
    )
end

function love.keypressed(key)
    if (key == "a") then
        if (regulateur.kmph + 10 > 240) then
            regulateur.kmph = 240
        else
            regulateur.kmph = regulateur.kmph + 10
        end
    end

    if (key == "z") then
        if (regulateur.kmph + 1 > 240) then
            regulateur.kmph = 240
        else
            regulateur.kmph = regulateur.kmph + 1
        end
    end

    if (key == "e") then
        if (regulateur.kmph - 1 < 0) then
            regulateur.kmph = 0
        else
            regulateur.kmph = regulateur.kmph - 1
        end
    end

    if (key == "r") then
        if (regulateur.kmph - 10 < 0) then
            regulateur.kmph = 0
        else
            regulateur.kmph = regulateur.kmph - 10
        end
    end

    if (key == "escape") then
        love.event.quit()
    end
end
