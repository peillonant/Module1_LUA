local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")
local mySpriteManager = require("Game/SpriteManager")

local coins = {}

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

    if (sceneState.DEBUGGERMODE == true) then
    end
end

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
local function CheckCollision(myCharact, localCoin)
    local dist = generalMethod.dist(localCoin.px, localCoin.py, myCharact.px, myCharact.py)

    if (dist < generalMethod.TILE_WIDTH / 2) then
        myCharact.nbCoin = myCharact.nbCoin + 1
        return true
    else
        return false
    end
end

-- Function called by the GameManager Update
function coins.UpdateCoins(dt, myCharact)
    for i = #coins[generalMethod.currentRoom], 1, -1 do
        local localCoin = coins[generalMethod.currentRoom][i]
        UpdateCurrentImage(dt, localCoin)

        if (CheckCollision(myCharact, localCoin)) then
            table.remove(coins, i)
        end
    end
end

-- Function called by the GameManager on the draw function
-- Bug lors du gameover
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
