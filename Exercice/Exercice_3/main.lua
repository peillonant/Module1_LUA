-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("Debugger")

Heart = {}
Heart.image = {}
Heart.image.full = love.graphics.newImage("images/full.png")
Heart.image.half_left = love.graphics.newImage("images/half_left.png")
Heart.image.half_right = love.graphics.newImage("images/half_right.png")
Heart.pdv = 4.5
Heart.nbrFull = 5
Heart.nbrHalf = 0
Heart.imageScale = 2
Heart.alpha = 1

function UpdateHeartToDisplay()
    Heart.nbrFull = math.floor(Heart.pdv)

    if ((Heart.pdv % Heart.nbrFull > 0) or (Heart.pdv > 0 and Heart.pdv < 1)) then
        Heart.nbrHalf = 1
    else 
        Heart.nbrHalf = 0
    end
end

function UpdateHealt(integer)
    local tmp = Heart.pdv + integer

    if (tmp < 5.5 and tmp > 0) then
        Heart.pdv = tmp
    end

    if (integer == 5) then
        Heart.pdv = 5
    end
end

-- a retravailler
function UpdateClignotement(dt)
    if (Heart.nbrFull == 0 and Heart.pdv > 0) then
        Heart.alpha = Heart.alpha + dt
        if (Heart.alpha > 1) then
            Heart.alpha = 0
        end
    else
        Heart.alpha = 1
    end
end

function DisplayFullHeart()
    local sizeHealtBar = (Heart.nbrFull*Heart.image.full:getWidth()*Heart.imageScale + Heart.nbrHalf*Heart.image.half_left:getWidth()*Heart.imageScale)/2

    if (Heart.nbrFull > 0) then
        love.graphics.setColor(1,1,1,1)
        for i=0,Heart.nbrFull-1 do
            local px = love.graphics.getWidth()/2 - sizeHealtBar + Heart.image.full:getWidth()*i*Heart.imageScale
            local py = 0
            love.graphics.draw(Heart.image.full, px , py , 0, Heart.imageScale, Heart.imageScale)
        end
    end

    if (Heart.nbrHalf > 0) then
        love.graphics.setColor(1,1,1,Heart.alpha)
        local px = love.graphics.getWidth()/2 - sizeHealtBar + (Heart.image.full:getWidth()*Heart.nbrFull*Heart.imageScale)
        local py = 0
        love.graphics.draw(Heart.image.half_left, px , py, 0, Heart.imageScale, Heart.imageScale)
    end
end

-- On this function, we are taking the risk of the size of the Half_left of the heart and the Half_right are the same size to form a full Heart when they have the same position
function DisplayFullHeart_by_half()
    local sizeHealtBar = (Heart.nbrFull*Heart.image.half_left:getHeight()*Heart.imageScale + Heart.nbrHalf*Heart.image.half_left:getHeight()*Heart.imageScale)/2

    if (Heart.nbrFull > 0) then
        love.graphics.setColor(1,1,1,1)
        for i=0,Heart.nbrFull-1 do
            local px = 0
            local py = love.graphics.getHeight()/2 - sizeHealtBar + Heart.image.half_left:getHeight()*i*Heart.imageScale
            
            love.graphics.draw(Heart.image.half_left, px , py , 0, Heart.imageScale, Heart.imageScale)
            love.graphics.draw(Heart.image.half_right, px , py , 0, Heart.imageScale, Heart.imageScale)
        end
    end

    if (Heart.nbrHalf > 0) then
        love.graphics.setColor(1,1,1,Heart.alpha)
        local px = 0
        local py = love.graphics.getHeight()/2 - sizeHealtBar + (Heart.image.half_left:getHeight()*Heart.nbrFull*Heart.imageScale)
        love.graphics.draw(Heart.image.half_left, px , py, 0, Heart.imageScale, Heart.imageScale)
    end
end

function DisplayTextExplication()
    -- Display command to impact the Healt
    love.graphics.setColor(1,1,1,1)

    local text_2 = {}
    text_2.string = "A for -1 / Z for -0.5 / E for +0.5 / R for +0.5 / T for Full Life"
    text_2.px = love.graphics.getWidth()/2 - Font:getWidth(text_2.string)/2
    text_2.py = love.graphics.getHeight()/2

    local text = {}
    text.string = "Here the command to impact the number of Heart"
    text.px = love.graphics.getWidth()/2 - Font:getWidth(text.string)/2
    text.py = love.graphics.getHeight()/2 - Font:getHeight(text_2.string)
    
    love.graphics.print(text.string, text.px , text.py )
    love.graphics.print(text_2.string, text_2.px , text_2.py )
end

function love.load()
    Font = love.graphics.newFont(16)
    love.graphics.setFont(Font)
end

function love.update(dt)
    UpdateHeartToDisplay()

    UpdateClignotement(dt)
end

function love.draw()

    -- Afficher les coeurs pleins
    DisplayFullHeart()

    -- Afficher les demi coeurs à la place des fullHeart
    DisplayFullHeart_by_half()

    DisplayTextExplication()

    -- Debugging Function to draw a cross on the screen
    --DebugDrawCrossMiddle()
end

function love.keypressed(key)
    if (key == "a") then
        -- reduce the healt by 1
        UpdateHealt(-1)
    end

    if (key == "z") then
        -- reduce the healt by 0.5
        UpdateHealt(-0.5)
    end

    if (key == "e") then
        -- healt by 0.5
        UpdateHealt(0.5)
    end

    if (key == "r") then
        -- healt by 1
        UpdateHealt(1)
    end

    if (key == "t") then
        -- Full heal
        UpdateHealt(5)
    end
end


--if (Heart.fullHeart == 0) then
--    -- Clignotement here
--    if (changeDisplay == true and previousState == "hide") then
--        local px = love.graphics.getWidth()/2 + ((Heart.full:getWidth()*Heart.imageScale)*Heart.fullHeart)
--        local py = 0
--
--        love.graphics.draw(Heart.half_left, px , py, 0, Heart.imageScale, Heart.imageScale )
--        
--        previousState = "display"
--        changeDisplay = false
--    elseif (changeDisplay == true and previousState == "display") then
--        previousState = "hide"
--        changeDisplay = false
--    end
--else