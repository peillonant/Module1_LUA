-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("PlayerManager")
require("ZombieManager")
require("InputManager")
require("Debugger")

Player = {}
Enemy = {}

function love.load()
    CreatePlayer()

end

function love.update(dt)
    InputeManager(dt)

    UpdatePlayerImage(dt)
end

function love.draw()
    DrawPlayer()
end

function love.keypressed(key)
end
