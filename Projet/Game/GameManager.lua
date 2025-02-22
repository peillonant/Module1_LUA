local generalMethod = require("GeneralMethod")
local myBonus = require("Entities/Bonus")
local myCharact = require("Game/CharacterManager")
local myLevel = require("Game/LevelManager")
local myEnemies = require("Game/EnemyManager")
local mySprite = require("Game/SpriteManager")
local myBullets = require("Game/BulletsManager")
local myHUD = require("Game/HUDManager")
local myCoins = require("Game/CoinManager")
local myAudio = require("Game/AudioManager")
local sceneState = require("MAE/SceneState")
local pauseMenu = require("Menu/PauseMenu")

local game = {}

local isPaused = false

function game.UdaptePause()
    isPaused = not isPaused
end

function game.InitGame()
    -- Be sure everything is set at null before launch the Init
    print("[GameManager] We are on the Reset part")
    generalMethod.InitVariable()

    -- Gestion des niveaux avec le load de l'ensemble des Enemies pour le niveau
    print("[GameManager] We are on the Init part")
    myLevel.LoadLevel()
    mySprite.LoadAGE(myEnemies)
    myCharact.InitCharacter()
    myBonus.InitBonus(myCharact)
end

function game.UpdateGame(dt)
    if (not isPaused) then

        myAudio.musicVolume = 0.65

        myCharact.UpdateCharact(dt, myEnemies, myLevel)
        myEnemies.UpdateEnemies(dt, myCharact, myLevel)
        myBullets.UpdateBullets(dt)
        myCoins.UpdateCoins(dt, myCharact)
        myLevel.UpdateLevel(dt)
    else
        myAudio.musicVolume = 0.75
        pauseMenu.UpdatePauseMenu()
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

        generalMethod.mouseVisible = true

        love.mouse.setVisible(generalMethod.mouseVisible)
    end
end

function game.MousePressed(px, py, button)
    if (isPaused) then
        pauseMenu.MousePressed(px, py, button, game)
    else
        sceneState.currentState = sceneState.GAME
    end
end

function game.KeyPressed(key)
    if (key == "escape" and pauseMenu.optionMenu == false) then
        isPaused = not isPaused

        generalMethod.mouseVisible = isPaused

        love.mouse.setVisible(generalMethod.mouseVisible)
    end

    if (isPaused) then
        pauseMenu.KeyPressed(key)
    else
        myCharact.KeyPressed(key, myLevel)
        myEnemies.KeyPressed(key)
    end
end

return game
