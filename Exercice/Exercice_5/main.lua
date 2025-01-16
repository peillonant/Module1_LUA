-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

require("Debugger")

Rectangle = {}
NbrRectangle = 0

-- We subtract 5 pixels to not have a position on the limit of the screen
GapScreen = 5

local ScreenArea = love.graphics.getWidth() * love.graphics.getHeight()
local ScreenAreaAvailable = ScreenArea

function CreateRectangle()
    for i = 1,NbrRectangle do
        Rectangle[i] = {}
        -- First Rectangle to be create
        if (i == 1) then
            -- Compute the Area Available if all rectangle has the same Area (to be sure that every Rectangle can be display without overlapping each other)
            local AreaAvailable = ScreenArea / NbrRectangle
            
            -- Generation of the position of the positon. As is the first Rectangle we can put it everywhere 
            Rectangle[i].px = love.math.random(1, love.graphics.getWidth() - GapScreen)
            Rectangle[i].py = love.math.random(1, love.graphics.getHeight() - GapScreen)

            -- Generation of the size of the Width of the rectangle
            Rectangle[i].sizeX = love.math.random(1, love.graphics.getWidth() - Rectangle[i].px)
            
            -- With the Width computed, we have to find the range of the Y to still respect the AreaAvailable per Rectangle
            local RangeY_Available = AreaAvailable / Rectangle[i].sizeX
            
            -- Condition to check if the Range of the Y is not outlimit
            if (RangeY_Available + Rectangle[i].py > love.graphics.getHeight() - Rectangle[i].py) then
                Rectangle[i].sizeY = love.math.random(1, love.graphics.getHeight() - Rectangle[i].py)
            else
                Rectangle[i].sizeY = love.math.random(1, RangeY_Available)
            end
            
        else
            local generatePosition = false

            local AreaAvailable = ScreenAreaAvailable / NbrRectangle-i

            -- While loop to generate the position of the new Rectangle and test it if the position generate is not overlapping a rectangle already created
            while (generatePosition == false) do
                Rectangle[i].px = love.math.random(1, love.graphics.getWidth() - GapScreen)
                Rectangle[i].py = love.math.random(1, love.graphics.getHeight() - GapScreen)

                generatePosition = ComparePositionRectangle(Rectangle[i].px, Rectangle[i].py, i)
            end
            
            -- We decide to generate first the size width before the height for every rectangle
            local RangeX_Available = FindRangeX_Available(i)

            -- Generation of the size of the Width of the rectangle
            Rectangle[i].sizeX = love.math.random(1, RangeX_Available)

            -- With the Width computed, we have to find the range of the Y to still respect the AreaAvailable per Rectangle
            local RangeY_Available = FindRangeY_Available(i, AreaAvailable)
            Rectangle[i].sizeY = love.math.random(1, RangeY_Available)
        end
        -- We update the ScreenAreaAvailable for the rest of Rectangle to be created
        ScreenAreaAvailable = ScreenArea - (Rectangle[i].sizeX * Rectangle[i].sizeY)
        
        -- Function to generate the random Color for the rectangle
        Rectangle[i].color = GenerateRandomColor()
    end
end

function ComparePositionRectangle(px, py, NbrCurrentRectangle)
    for i = 1,NbrCurrentRectangle-1 do
        if ((px >= Rectangle[i].px and px <= Rectangle[i].px + Rectangle[i].sizeX) and (py >= Rectangle[i].py and py <= Rectangle[i].py+Rectangle[i].sizeY)) then
            return false
        end
    end
    return true
end

function FindRangeX_Available(NbrCurrentRectangle)
    -- Maximum the Range_Available is the size of the screen
    local Range_Available = love.graphics.getWidth() - Rectangle[NbrCurrentRectangle].px

    -- We check all previous rectangle
    for i= 1,NbrCurrentRectangle-1 do
        -- First condition, to avoid to take into account previous reclangle on the left of the new rectangle
        if  (Rectangle[NbrCurrentRectangle].px <= Rectangle[i].px or Rectangle[NbrCurrentRectangle].px <= Rectangle[i].px + Rectangle[i].sizeX)  then
            
            -- Second condtion, the rectangle has the area on the same Height of the new rectangle
            if (Rectangle[NbrCurrentRectangle].py >= Rectangle[i].py and Rectangle[NbrCurrentRectangle].py <= Rectangle[i].py + Rectangle[i].sizeY) then
                
                -- Third condition, does the Range_Available is overlapping the rectangle
                if (Rectangle[NbrCurrentRectangle].px + Range_Available >= Rectangle[i].px) then
                    Range_Available = Rectangle[i].px - Rectangle[NbrCurrentRectangle].px
                end
            end
        end
    end

    return Range_Available
end

function FindRangeY_Available(NbrCurrentRectangle, AreaAvailable)
    local RangeY_Available = love.graphics.getHeight() - Rectangle[NbrCurrentRectangle].py

    -- We check all previous rectangle
    for i= 1, NbrCurrentRectangle-1 do
        -- First condition, take into account rectangle with a position that can be overlapping by the new rectangle
        if  (Rectangle[NbrCurrentRectangle].px >= Rectangle[i].px and Rectangle[NbrCurrentRectangle].px <= Rectangle[i].px + Rectangle[i].sizeX)  or
            (Rectangle[i].px >= Rectangle[NbrCurrentRectangle].px and Rectangle[i].px <= Rectangle[NbrCurrentRectangle].px + Rectangle[NbrCurrentRectangle].sizeX) or
            (Rectangle[i].px + Rectangle[i].sizeX >= Rectangle[NbrCurrentRectangle].px and Rectangle[i].px + Rectangle[i].sizeX <= Rectangle[NbrCurrentRectangle].px + Rectangle[NbrCurrentRectangle].sizeX) then
            
            -- Second Condition, to not take into account Rectangle with a Height above the new rectangle
            if (Rectangle[NbrCurrentRectangle].py <= Rectangle[i].py) then
                -- Thrid Condition, check the position of the Y and compare with the RangeY_Available
                if (Rectangle[NbrCurrentRectangle].py + RangeY_Available >= Rectangle[i].py) then
                    RangeY_Available = Rectangle[i].py - Rectangle[NbrCurrentRectangle].py
                end
            elseif (Rectangle[NbrCurrentRectangle].py <= Rectangle[i].py + Rectangle[i].sizeY) then
                -- Thrid Condition, check the position of the Y and compare with the RangeY_Available
                if (Rectangle[NbrCurrentRectangle].py + RangeY_Available >= Rectangle[i].py + Rectangle[i].sizeY) then
                    RangeY_Available = Rectangle[i].py + Rectangle[i].sizeY - Rectangle[NbrCurrentRectangle].py
                end
            end

        end
    end

    return RangeY_Available
end

function GenerateRandomColor()
    local color = {}
    color.R = love.math.random(0,255)
    color.G = love.math.random(0,255)
    color.B = love.math.random(0,255)
    return color
end

function FindTheRectangle(mx, my)
    for i=1,NbrRectangle do
        if (mx >= Rectangle[i].px and mx <= Rectangle[i].px + Rectangle[i].sizeX) and
            (my >= Rectangle[i].py and my <= Rectangle[i].py + Rectangle[i].sizeY) then
                return i
        end
    end

    return -1
end

function love.load()
    NbrRectangle = 100
    CreateRectangle()

    for i = 1, NbrRectangle do
        print(i,Rectangle[i].px, Rectangle[i].py, Rectangle[i].sizeX, Rectangle[i].sizeY)
    end
end

function love.mousepressed(mx, my, mbutton)
    if mbutton == 1 then -- check the Left click 
        
        local indexRectangle = FindTheRectangle(mx, my)
    
        if ( indexRectangle > 0 ) then
            print("You clicked on this rectangle => "..tostring(indexRectangle))
        else
            print("Click outside of any rectangle with the coordonate of => "..tostring(mx).." / "..tostring(my))
        end
    end
end

function love.draw()
    -- Draw Cross Middle Screen
    --DebugDrawCrossMiddle()

    for i= 1,NbrRectangle do
        love.graphics.setColor(love.math.colorFromBytes(Rectangle[i].color.R,Rectangle[i].color.G,Rectangle[i].color.B ))
        love.graphics.rectangle("fill", Rectangle[i].px, Rectangle[i].py, Rectangle[i].sizeX, Rectangle[i].sizeY)
        love.graphics.setColor(1,1,1,1)
        --love.graphics.print(i, Rectangle[i].px, Rectangle[i].py)
    end
end