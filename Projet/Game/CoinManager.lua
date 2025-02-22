local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")
local mySpriteManager = require("Game/SpriteManager")
local myAudio = require("Game/AudioManager")

local coins = {}

---------------------------------  LOCAL FUNCTION  ----------------------------------------

-- Function that update the Frame of the Image
local function UpdateCurrentImage(dt, localCoin)
    if (localCoin ~= nil) then
        localCoin.timeSinceLastChangeImage = localCoin.timeSinceLastChangeImage + dt

        if (localCoin.timeSinceLastChangeImage > localCoin.delay) then
            localCoin.currentIndexImage = localCoin.currentIndexImage + 1
            localCoin.timeSinceLastChangeImage = 0
        end

        if (localCoin.currentIndexImage > localCoin.indexMax) then
            localCoin.currentIndexImage = localCoin.indexMin
        end
    end
end

-- Check if the dist between the coin and the charact is below 50 pixel
-- If Yes, we add the coin on the inventory of the Charact and remove the coin from the list
-- WORKING ON THAT WITH THE NEW COLLIDER SYSTEM
local function CheckCollision(myCharact, localCoin)
    if (localCoin ~= nil) then
        local PositionX = localCoin.px + generalMethod.TILE_WIDTH / 2
        local PositionY = localCoin.py + generalMethod.TILE_HEIGHT / 2

        local dist = generalMethod.dist(PositionX , PositionY, myCharact.px, myCharact.py)

        if (dist < generalMethod.TILE_WIDTH / 2) then
            myCharact.nbCoin = myCharact.nbCoin + 1
            return true
        else
            return false
        end
    else
        return false
    end
end

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function called by the LevelManager to create a line of the Coin tab for each Room
function coins.LinkedRoom(nbrRooms)
    for i = 1, nbrRooms do
        coins[i] = {}
    end
end

-- function called by the EnemyManager when the Enemy HP is fallin at 0
function coins.CreateCoins(nbrCoin, entityPX, entityPY)
    for i = 1, nbrCoin do
        local newCoin = {}
        newCoin.px = entityPX + love.math.random(-5, 5)
        newCoin.py = entityPY + love.math.random(-5, 5)
        newCoin.currentIndexImage = love.math.random(1, 8)

        newCoin.timeSinceLastChangeImage = 0
        newCoin.delay = 0.1

        newCoin.indexMin = 1
        newCoin.indexMax = #mySpriteManager.items.coins.frame

        table.insert(coins[generalMethod.currentRoom], newCoin)
    end
end

-- Function called by the GameManager Update
function coins.UpdateCoins(dt, myCharact)
    for i = #coins[generalMethod.currentRoom], 1, -1 do
        local localCoin = coins[generalMethod.currentRoom][i]
        UpdateCurrentImage(dt, localCoin)

        if (CheckCollision(myCharact, localCoin)) then
            myAudio.playSound(myAudio.coin)
            table.remove(coins[generalMethod.currentRoom], i)
        end
    end
end

-- Function called by the GameManager on the draw function
function coins.DrawCoin()
    for i = 1, #coins[generalMethod.currentRoom] do
        local localCoin = coins[generalMethod.currentRoom][i]
        local frameQuad = mySpriteManager.items.coins.frame[localCoin.currentIndexImage]
        local tileSheet = mySpriteManager.items.coins.TileSheet

        if (frameQuad ~= nil) then
            love.graphics.draw(tileSheet, frameQuad, localCoin.px, localCoin.py, 0, 0.75, 0.75)
        end
    end
end

return coins
