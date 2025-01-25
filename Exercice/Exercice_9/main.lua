-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

-- appliquer le current timer sur chacun des character

local col1 = {}
local col2 = {}
local col3 = {}

local antoine = {}
local lucille = {}
local gilles = {}
local veronique = {}
local kevin = {}
local fanny = {}
local maxime = {}
local sarah = {}
local thib = {}
local jenny = {}

function AddTimer(charac)
    charac.timer = love.math.random(3, 10)
    charac.currentTime = 0
end

function AddToCol(charact, colToAdd, index)
    table.insert(colToAdd, charact)
    charact.indexCol = index
    AddTimer(charact)
end

function love.load()
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key)
end
