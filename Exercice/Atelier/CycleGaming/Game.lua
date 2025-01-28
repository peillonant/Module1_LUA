local game = {}

local myScene = require("Scene")

local cube = {}
cube.px = 0
cube.py = 0
cube.size = 10
cube.speed = 60

local currentTimer = 0
local endGameTimer = 5

local listStars = {}

function game.StartGame()
    currentTimer = 0
    for s = 1, 300 do
        local star = {}
        star.px = love.math.random(1, love.graphics.getWidth() - 1)
        star.py = love.math.random(1, love.graphics.getHeight() - 1)
        star.couleur = {}
        star.couleur.R = love.math.random(0, 255)
        star.couleur.G = love.math.random(0, 255)
        star.couleur.B = love.math.random(0, 255)
        star.couleur.A = 255
        star.size = 2.5
        table.insert(listStars, star)
    end
end

function game.InitGame()
    cube.px = 0
    cube.py = 0

    listStars = {}

    game.StartGame()
end

function game.UpdateGame(dt)
    if love.keyboard.isDown("up") then
        cube.py = cube.py - cube.speed * dt
    end
    if love.keyboard.isDown("right") then
        cube.px = cube.px + cube.speed * dt
    end
    if love.keyboard.isDown("down") then
        cube.py = cube.py + cube.speed * dt
    end
    if love.keyboard.isDown("left") then
        cube.px = cube.px - cube.speed * dt
    end

    for s = 1, #listStars do
        if
            ((listStars[s].px >= cube.px and listStars[s].px <= cube.px + cube.size) and
                (listStars[s].py >= cube.py and listStars[s].py <= cube.py + cube.size) and
                listStars[s].couleur.A == 255)
         then
            listStars[s].couleur.R = 255
            listStars[s].couleur.G = 255
            listStars[s].couleur.B = 255
            listStars[s].couleur.A = 255
            currentTimer = 0
        end
    end

    currentTimer = currentTimer + dt

    if currentTimer >= endGameTimer then
        return myScene.GAMEOVER
    else
        return myScene.GAME
    end
end

function game.DrawGame()
    love.graphics.print("GAME", 10, 10)

    love.graphics.print(tostring(math.floor(currentTimer)), love.graphics.getWidth() - 100, 10)

    love.graphics.rectangle("line", cube.px, cube.py, cube.size, cube.size)

    for s = 1, #listStars do
        love.graphics.setColor(
            love.math.colorFromBytes(
                listStars[s].couleur.R,
                listStars[s].couleur.G,
                listStars[s].couleur.B,
                listStars[s].couleur.A
            )
        )
        love.graphics.circle("fill", listStars[s].px, listStars[s].py, listStars[s].size)
    end
    love.graphics.setColor(1, 1, 1)
end

return game
