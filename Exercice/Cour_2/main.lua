-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

love.graphics.setDefaultFilter("nearest", "nearest", 1)

-- Chargement de l'adresse du Module dans la variable
local monModule = require("fondstars")

-- Fonction appelée 1 seule fois au lancement d'une application Löve
function love.load()
    monModule.CreeToutesLesEtoiles()
end

function love.update(dt)
    monModule.DeplaceEtoile(dt)
end

function love.draw()
    monModule.DrawEtoile()
end

function love.keypressed(key)
    if key == "escape" then
        monModule.CreeToutesLesEtoiles()
    end
    if key == "space" then
        monModule.InverseDirection()
    end
end
