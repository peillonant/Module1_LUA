-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local lTank = {}
local lSpawnPosition = {}
lSpawnPosition[1] = {px = 100, py = 100}
lSpawnPosition[2] = {px = 700, py = 100}
lSpawnPosition[3] = {px = 100, py = 500}
lSpawnPosition[4] = {px = 700, py = 500}
local imgTank = love.graphics.newImage("image/Tank.png")
local tSpawner = 2
local tCurrentTime = 0

function math.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function CreateTank()
    local pTank = {}
    local indexSpawner = love.math.random(1, 4)
    pTank.px = lSpawnPosition[indexSpawner].px
    pTank.py = lSpawnPosition[indexSpawner].py
    pTank.speed = love.math.random(1, 5)
    pTank.vx = 1
    pTank.vy = 1
    pTank.angle = 0
    pTank.bChangeDir = true

    table.insert(lTank, pTank)
end

function ChangeDir(tank)
    tank.angle =
        math.angle(
        tank.px,
        tank.py,
        love.math.random(0, love.graphics.getWidth()),
        love.math.random(0, love.graphics.getHeight())
    )
    tank.vx = tank.speed * 60 * math.cos(tank.angle)
    tank.vy = tank.speed * 60 * math.sin(tank.angle)
    tank.bChangeDir = false
end

function RemoveTank()
    for i = #lTank, 1, -1 do
        if
            ((lTank[i].px < 0 or lTank[i].px > love.graphics.getWidth()) or
                (lTank[i].py < 0 or lTank[i].py > love.graphics.getHeight()))
         then
            table.remove(lTank, i)
        end
    end
end

function love.load()
end

function love.update(dt)
    -- Spawner
    if (tCurrentTime > tSpawner) then
        CreateTank()
        tCurrentTime = 0
    end

    tCurrentTime = tCurrentTime + dt

    -- Movement of the Tank
    for i = 1, #lTank do
        -- Change the direction of the Tank after each Spawner
        if (lTank[i].bChangeDir) then
            ChangeDir(lTank[i])
        end

        if (tCurrentTime > tSpawner) then
            lTank[i].bChangeDir = true
        end

        lTank[i].px = lTank[i].px + lTank[i].vx * dt
        lTank[i].py = lTank[i].py + lTank[i].vy * dt
    end

    -- Remove Tank not anymore on the screen
    RemoveTank()
end

function love.draw()
    for i = 1, #lTank do
        love.graphics.draw(
            imgTank,
            lTank[i].px,
            lTank[i].py,
            lTank[i].angle,
            1,
            1,
            imgTank:getWidth() / 2,
            imgTank:getHeight() / 2
        )
    end

    for n = 1, #lSpawnPosition do
        love.graphics.rectangle("fill", lSpawnPosition[n].px, lSpawnPosition[n].py, 10, 10)
    end
end

function love.keypressed(key)
    if (key == "escape") then
        love.event.quit()
    end
end
