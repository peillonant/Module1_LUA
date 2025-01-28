-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

DEFAULTSCALE = 2

-- General Setting for the Projet
love.graphics.setDefaultFilter("nearest")
love.window.setMode(1024, 768)
love.graphics.scale(DEFAULTSCALE, DEFAULTSCALE)
--

local myMenu = require("Menu")
local myGame = require("Game")
local sceneState = require("SceneState")

local currentState = sceneState.MENU

function love.load()
    myMenu.InitMenu(sceneState)
end

function love.update(dt)
    if (currentState == sceneState.MENU) then
        myMenu.UpdateMenu()
    elseif (currentState == sceneState.GAME) then
    elseif (currentState == sceneState.GAMEOVER) then
    elseif (currentState == sceneState.WIN) then
    end
end

function love.draw()
    if (currentState == sceneState.MENU) then
        myMenu.DrawMenu()
    elseif (currentState == sceneState.GAME) then
        myGame.DrawGame()
    elseif (currentState == sceneState.GAMEOVER) then
    elseif (currentState == sceneState.WIN) then
    end
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end
end

function love.mousepressed(px, py, button)
    if (currentState == sceneState.MENU) then
        local newState = myMenu.MousePressed(px, py, button)
        if (newState == sceneState.GAME) then
            myGame.InitGame()
            currentState = newState
        end
    end
end
