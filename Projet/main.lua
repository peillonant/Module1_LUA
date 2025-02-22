-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- General Setting for the Projet
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local generalMethod = require("GeneralMethod")
local myGame = require("Game/GameManager")
local myAudio = require("Game/AudioManager")
local sceneState = require("MAE/SceneState")
local myMenu = require("Menu/MenuManager")


function love.load()
    love.graphics.setBackgroundColor(0.45, 0.31, 0.21)
    myAudio.InitSound()
end

function love.update(dt)
    myAudio.UpdateBackgroundMusic()
    
    if (sceneState.currentState == sceneState.MENU) then
        myMenu.UpdateMenu()
    elseif (sceneState.currentState == sceneState.GAME) then
        myGame.UpdateGame(dt)
    elseif (sceneState.currentState == sceneState.GAMEOVER) then
    elseif (sceneState.currentState == sceneState.WIN) then
    end

    love.mouse.setVisible(generalMethod.mouseVisible)
end

function love.draw()
    if (sceneState.currentState == sceneState.MENU) then
        myMenu.DrawMenu()
    elseif (sceneState.currentState == sceneState.GAME) then
        myGame.DrawGame()
    elseif (sceneState.currentState == sceneState.GAMEOVER) then
        love.graphics.print(
            "GAME OVER",
            (love.graphics.getWidth() - generalMethod.DefaultFont:getWidth("GAME OVER")) / 2,
            (love.graphics.getHeight() - generalMethod.DefaultFont:getHeight()) / 2
        )
    elseif (sceneState.currentState == sceneState.WIN) then
        love.graphics.print(
            "WIN",
            (love.graphics.getWidth() - generalMethod.DefaultFont:getWidth("WIN")) / 2,
            (love.graphics.getHeight() - generalMethod.DefaultFont:getHeight()) / 2
        )
    end
end

function love.keypressed(key)
    if (sceneState.currentState == sceneState.MENU) then
        myMenu.KeyPressed(key)
    end

    if (sceneState.currentState == sceneState.GAME) then
        myGame.KeyPressed(key)
    end

    if (sceneState.currentState == sceneState.GAMEOVER or sceneState.currentState == sceneState.WIN) then
        if (key == "space") then
            generalMethod.mouseVisible = true
            sceneState.currentState = sceneState.MENU
        end
    end
end

function love.focus(f)
    if (sceneState.currentState == sceneState.GAME) then
        myGame.Focus(f)
    end
end

function love.mousepressed(px, py, button)
    if (sceneState.currentState == sceneState.MENU) then
        sceneState.currentState = myMenu.MousePressed(px, py, button)

        if (sceneState.currentState == sceneState.NEWGAME) then
            myGame.InitGame()
            love.mouse.setVisible(generalMethod.mouseVisible)
            sceneState.currentState = sceneState.GAME
        end
    end

    if (sceneState.currentState == sceneState.GAME) then
        myGame.MousePressed(px, py, button)
    end
end
