-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local fusee = {
    px,
    py,
    speed = 100,
    img = love.graphics.newImage("images/fusee.png")
}

local reactor = {
    px,
    py,
    img = love.graphics.newImage("images/reacteur.png")
}

local startEngine = true
local stepLaunching = 0
local timeRemaining = 40
local gapTime = 30

local fontStartLaunching = love.graphics.newFont(20)
local fontStepLaunching = love.graphics.newFont(30)
local fontTimeRemaining = love.graphics.newFont(35)
local fontTimeRemainingCaps = love.graphics.newFont(40)

--Celle-ci est posée au sol, à l'arrêt
--Un compte à rebours de 40 secondes démarre quand on appuie sur une touche
--La fusée suit les étapes suivantes :
--10 secondes de "évacuez la tour" (stepLaunching = 1) 40 -> 30
--10 secondes de "préparez le pas de tir" (stepLaunching = 2) 30 -> 20
--10 secondes "retrait des bras cryogéniques" (stepLaunching = 3) 20 -> 10
--10 secondes "lancez les moteurs" (steplaunching = 4) 10 -> 0
--Décollage (animez la fusée pour qu'elle décolle) (steplaunching = 5)
--Le programme affiche "Décollage réussi" quand la fusée a quitté l'écran (steplaunching = 6)

function printStepText()
    local text
    local font

    if (startEngine) then
        font = fontStartLaunching
        text = "Press Space on your keyboard to launch the rocket"
    else
        if (math.floor(timeRemaining) % 10 == 0 and math.floor(timeRemaining) > 0) then
            font = fontTimeRemainingCaps
        else
            font = fontTimeRemaining
        end

        -- Print TimeRemaining
        love.graphics.print(math.floor(timeRemaining), love.graphics.getWidth() - 100, 100)

        -- Print Text for each step
        font = fontStepLaunching
        if (stepLaunching == 1) then
            text = "Evacuez la tour"
        elseif (stepLaunching == 2) then
            text = "Préparez le pas de tir"
        elseif (stepLaunching == 3) then
            text = "Retrait des bras cryogéniques"
        elseif (stepLaunching == 4) then
            text = "Lancez les moteurs"
        elseif (stepLaunching == 6) then
            text = "Décollage réussi"
        else
            text = ""
        end
    end

    love.graphics.setFont(font)
    love.graphics.print(text, love.graphics.getWidth() / 2 - font:getWidth(text) / 2, love.graphics.getHeight() / 4)
end

function love.load()
    fusee.px = love.graphics.getWidth() / 2 - fusee.img:getWidth() / 2
    fusee.py = love.graphics.getHeight() - fusee.img:getHeight()
end

function love.update(dt)
    if (stepLaunching > 0) then
        if (timeRemaining > 0) then
            timeRemaining = timeRemaining - dt
        end

        if (timeRemaining < gapTime and gapTime > 0) then
            stepLaunching = stepLaunching + 1
            gapTime = gapTime - 10
            print(stepLaunching)
        end

        if (math.floor(timeRemaining) == 0 and stepLaunching < 5) then
            stepLaunching = 5
            print(stepLaunching)
        end

        if (math.floor(timeRemaining) == 0) then
            timeRemaining = 0

            fusee.py = fusee.py - fusee.speed * dt

            -- update the position of the reactor
            reactor.px = fusee.px + fusee.img:getWidth() / 2 + reactor.img:getWidth() / 2
            reactor.py = fusee.py + fusee.img:getHeight() + reactor.img:getHeight() / 2
        end

        if (fusee.py + fusee.img:getHeight() < 0 and stepLaunching ~= 6) then
            stepLaunching = 6
        end
    end
end

function love.draw()
    printStepText()

    if (stepLaunching < 6) then
        if (stepLaunching >= 5) then
            love.graphics.draw(reactor.img, reactor.px - reactor.img:getWidth(), reactor.py, math.rad(180))
            love.graphics.draw(reactor.img, reactor.px, reactor.py, math.rad(180))
            love.graphics.draw(reactor.img, reactor.px + reactor.img:getWidth(), reactor.py, math.rad(180))
        end

        love.graphics.draw(fusee.img, fusee.px, fusee.py)
    end
end

function love.keypressed(key)
    if (key == "space") then
        startEngine = false
        stepLaunching = 1
    end

    if (key == "escape") then
        love.event.quit()
    end
end
