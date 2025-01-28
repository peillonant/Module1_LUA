-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

love.graphics.setDefaultFilter("nearest")

local currentScene

local sceneState = require("Scene")
local menu = require("Menu")
local game = require("Game")
local gameover = require("Gameover")

function love.load()
    currentScene = sceneState.MENU
    game.StartGame()
end

function love.update(dt)
    if (currentScene == sceneState.MENU) then
        menu.UpdateMenu(dt)
    elseif (currentScene == sceneState.GAME) then
        currentScene = game.UpdateGame(dt)
    elseif (currentScene == sceneState.GAMEOVER) then
        gameover.UpdateGameOver(dt)
    end
end

function love.draw()
    if (currentScene == sceneState.MENU) then
        menu.DrawMenu()
    elseif (currentScene == sceneState.GAME) then
        game.DrawGame()
    elseif (currentScene == sceneState.GAMEOVER) then
        gameover.DrawGameOver()
    end
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end

    if (key == "a" and currentScene ~= sceneState.MENU) then
        currentScene = sceneState.MENU
    end

    if (key == "z" and currentScene ~= sceneState.GAME) then
        currentScene = sceneState.GAME
    end

    if (key == "space" and currentScene == sceneState.GAME) then
        game.InitGame()
    end

    if (key == "space" and currentScene == sceneState.GAMEOVER) then
        game.InitGame()
        currentScene = sceneState.GAME
    end
end
