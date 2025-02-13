-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local generalMethod = require("GeneralMethod")
local myGame = require("Game/GameManager")
local sceneState = require("MAE/SceneState")
local myMenu = require("Menu/MenuManager")

-- General Setting for the Projet
love.graphics.setDefaultFilter("nearest")
--love.window.setMode(1024, 768)

local currentState = sceneState.MENU

function love.load()
    -- Lets go directly to the GAME
    --currentState = sceneState.GAME
    myGame.InitGame()
end

function love.update(dt)
    if (currentState == sceneState.MENU) then
        myMenu.UpdateMenu()
    elseif (currentState == sceneState.GAME) then
        currentState = myGame.UpdateGame(dt)
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
        love.graphics.print(
            "GAME OVER",
            (love.graphics.getWidth() - generalMethod.DefaultFont:getWidth("GAME OVER")) / 2,
            (love.graphics.getHeight() - generalMethod.DefaultFont:getHeight()) / 2
        )
    elseif (currentState == sceneState.WIN) then
    end
end

function love.keypressed(key)
    if (key == "escape" and currentState == sceneState.MENU) then
        love.event.quit()
    end

    -- if (key == "escape" and sceneState.DEBUGGERMODE) then
    --     love.event.quit()
    -- end

    if (currentState == sceneState.MENU) then
        currentState = myMenu.KeyPressed(key)
        if (currentState == sceneState.NEWGAME) then
            myGame.InitGame()
            currentState = sceneState.GAME
        end
    end

    if (currentState == sceneState.GAME) then
        myGame.KeyPressed(key)
    end

    if (currentState == sceneState.GAMEOVER) then
        if (key == "space") then
            currentState = sceneState.MENU
        end
    end
end

function love.focus(f)
    if (currentState == sceneState.GAME) then
        myGame.Focus(f)
    end
end

function love.mousepressed(px, py, button)
    if (currentState == sceneState.MENU) then
        currentState = myMenu.MousePressed(px, py, button)
        if (currentState == sceneState.NEWGAME) then
            myGame.InitGame()
            generalMethod.mouseVisible = false
            love.mouse.setVisible(generalMethod.mouseVisible)
            currentState = sceneState.GAME
        end
    end

    if (currentState == sceneState.GAME) then
        currentState = myGame.MousePressed(px, py, button)
    end
end
