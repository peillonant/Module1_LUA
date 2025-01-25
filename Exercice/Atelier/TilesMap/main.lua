-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local myGame = require("game")

love.graphics.setDefaultFilter("nearest")
love.window.setMode(1024, 768)

function love.load()
    myGame.Load()
end

function love.update(dt)
end

function love.draw()
    myGame.Draw()
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end
end
