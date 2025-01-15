-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

require("Debugger")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

Floor = love.graphics.newImage("images/etage.png")

Building = {}
Building.nbrBuilding = 0
Building.sizeScale = 2

function CreateBuilding()    
    for i=1,Building.nbrBuilding do
        Building[i] = {}
        Building[i].nbrEtage = math.random(1, 10)
        
        for j=1,Building[i].nbrEtage do
            Building[i][j] = {}
            Building[i][j].alpha = 0

            if (j == 1) then
                Building[i][j].alpha = 1
            end
        end
    end
end

function DrawingBuilding_LookingAtTheTop()
    -- Variable to center all the buidling by the middle of the screen
    local Image_ox = Floor:getWidth()*Building.nbrBuilding*Building.sizeScale / 2

    for i=1,Building.nbrBuilding do
        for j=1,Building[i].nbrEtage do
            local px, py
            
            px = love.graphics.getWidth()/2 + Floor:getWidth()*(i-1)*Building.sizeScale - Image_ox

            -- no need to multiplys by Building.sizeScale because we have to add the multiplier on the top and bottom
            -- Moreover, we have also '- Floor:getHeight()*Building.sizeScale' to display the Building looking at the top above the middle of the screen
            py = love.graphics.getHeight()/2 - Floor:getHeight()*Building.sizeScale - Floor:getHeight()*(j-1)/2  
            
            love.graphics.setColor(1,1,1,Building[i][j].alpha)
            love.graphics.draw(Floor, px, py, 0, Building.sizeScale, Building.sizeScale)
        end
    end
end

function DrawingBuilding_LookingAtTheBottom()
    -- Variable to center all the buidling by the middle of the screen
    local Image_ox = Floor:getWidth()*Building.nbrBuilding*Building.sizeScale / 2

    for i=1,Building.nbrBuilding do
        for j=1,Building[i].nbrEtage do
            local px, py
            
            px = love.graphics.getWidth()/2 + Floor:getWidth()*(i-1)*Building.sizeScale - Image_ox

            -- no need to multiplys by Building.sizeScale because we have to add the multiplier on the top and bottom
            -- Moreover, we have also '+ Floor:getHeight()*Building.sizeScale' to display the Building looking at the bottom below the middle of the screen
            py = love.graphics.getHeight()/2 + Floor:getHeight()*Building.sizeScale + Floor:getHeight()*(j-1)/2

            love.graphics.setColor(1,1,1,Building[i][j].alpha)
            love.graphics.draw(Floor, px, py, 0, Building.sizeScale, -Building.sizeScale)
        end
    end
end

function love.load()
    Building.nbrBuilding = 10
    CreateBuilding()
end

function love.update(dt)
    -- Start to display level by level
    for i=2,Building.nbrBuilding do        
        for j=2,Building[i].nbrEtage do
            if (Building[i][j-1].alpha == 1) then
                if (Building[i][j].alpha < 1) then
                    Building[i][j].alpha = Building[i][j].alpha + dt
                elseif (Building[i][j].alpha > 1) then
                    Building[i][j].alpha = 1
                end
            end
        end
    end
end

function love.draw()
    -- Debugger to see the middle of the screen
    --DebugDrawCrossMiddle()

    -- DrawingBuilding
    DrawingBuilding_LookingAtTheTop()

    -- DrawingBuilding
    DrawingBuilding_LookingAtTheBottom()
end

function love.keypressed(key)
end
