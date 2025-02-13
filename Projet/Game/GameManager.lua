local generalMethod = require("GeneralMethod")
local myBonus = require("Entities/Bonus")
local myCharact = require("Game/CharacterManager")
local myLevel = require("Game/LevelManager")
local myEnemies = require("Game/EnemyManager")
local mySprite = require("Game/SpriteManager")
local myBullets = require("Game/BulletsManager")
local myHUD = require("Game/HUDManager")
local myCoins = require("Game/CoinManager")
local sceneState = require("MAE/SceneState")
local pauseMenu = require("Menu/PauseMenu")

local game = {}

local isPaused = false

function game.UdaptePause()
    isPaused = not isPaused
end

function game.InitGame()
    -- Gestion des niveaux avec le load de l'ensemble des Enemies pour le niveau
    mySprite.LoadAGE(myEnemies)
    myCharact.InitCharacter()
    myLevel.LoadLevel()
    myBonus.InitBonus(myCharact)
end

function game.UpdateGame(dt)
    if (not isPaused) then
        myCharact.UpdateCharact(dt, myEnemies, myLevel)
        myEnemies.UpdateEnemies(dt, myCharact, myLevel)
        myBullets.UpdateBullets(dt)
        myCoins.UpdateCoins(dt, myCharact)
        myLevel.UpdateLevel(dt, myCharact)
    else
        pauseMenu.UpdatePauseMenu()
    end

    if (myCharact.hp <= 0) then
        return sceneState.GAMEOVER
    else
        return sceneState.GAME
    end
end

function game.DrawGame()
    love.graphics.push("all")

    love.graphics.scale(generalMethod.DEFAULTSCALE)

    love.graphics.translate(generalMethod.cameraX, generalMethod.cameraY)

    myLevel.DrawCurrentRoom()
    myEnemies.DrawEnemies()
    myCharact.DrawCharacter()
    myBullets.DrawBullets()
    myCoins.DrawCoin()

    love.graphics.pop()

    myHUD.DrawHUD()

    if (isPaused) then
        pauseMenu.DrawPauseMenu()
    end
end

function game.Focus(f)
    if (f == false) then
        isPaused = not f
    end
end

function game.MousePressed(px, py, button)
    if (isPaused) then
        return pauseMenu.MousePressed(px, py, button, game)
    else
        return sceneState.GAME
    end
end

function game.KeyPressed(key)
    myCharact.KeyPressed(key, myLevel)
    myEnemies.KeyPressed(key)

    if (key == "escape") then
        isPaused = not isPaused

        generalMethod.mouseVisible = not generalMethod.mouseVisible

    --love.mouse.setVisible(generalMethod.mouseVisible)
    end
end

return game
