-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("PlayerManager")
require("ZombieManager")
require("InputManager")
require("Debugger")

local player = {}
local zombies = {}

function love.load()
    player = CreatePlayer()

    for i = 1, 10 do
        table.insert(zombies, CreateZombie(player))
    end
end

function love.update(dt)
    -- Managing movement
    InputeManager(player, dt)
    UpdateZombieMovement(dt)

    -- Update Player Image
    UpdatePlayerImage(dt)

    -- Update the bleeding of the player
    Attacked(zombies, dt)
end

function love.draw()
    DrawPlayer()

    DrawEnemie()
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end

    if (key == "p") then
        player.hp = player.hp - 5
    end

    if (key == "m") then
        player.hp = player.hp + 5
    end

    if (key == "o") then
        print(player.hp)
    end
end
