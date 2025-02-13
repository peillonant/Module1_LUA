-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setBackgroundColor(.2, .3, .1)

-- Charger un module
local monModuleStars = require("fondstars")
local myPlayer = require("player")
local myBullets = require("bullets")

-- Fonction appelée 1 seule fois au lancement d'une application Löve
function love.load()
    monModuleStars.CreeToutesLesEtoiles()
end

function love.update(dt)
    monModuleStars.deplaceEtoiles(dt)
    myPlayer.Update(dt)
    myBullets.UpdateBullets(dt)
end

function love.draw()
    monModuleStars.dessineEtoiles()
    myPlayer.Draw()
    myBullets.DrawBullets()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "c" then
        monModuleStars.CreeToutesLesEtoiles()
    end
    if key == "space" then
        myBullets.CreateBullets(myPlayer.px, myPlayer.py, myPlayer.r)
    end
    if key == "i" then
        monModuleStars.InverseDirection()
    end
end
