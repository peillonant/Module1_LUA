local generalMethod = {}

generalMethod.DEFAULTSCALE = 2

generalMethod.TILE_HEIGHT = 32
generalMethod.TILE_WIDTH = 32

generalMethod.WORLDWIDTH = 512
generalMethod.WORLDHEIGHT = 384

generalMethod.DefaultFont = love.graphics.getFont()
generalMethod.HUDInfoFont = love.graphics.newFont(17.5)
generalMethod.ItemInfoFont = love.graphics.newFont(11.5)
generalMethod.textMenu = love.graphics.setNewFont(30)
generalMethod.textPause = love.graphics.setNewFont(20)

generalMethod.color = {}
generalMethod.color.default = {r = 1, g = 1, b = 1}
generalMethod.color.mouseOver = {r = 0, g = 0, b = 0}
generalMethod.color.notAvailable = {r = 0.5, g = 0.5, b = 0.5}

generalMethod.currentLevel = 1
generalMethod.currentRoom = 6

generalMethod.cameraX = 0
generalMethod.cameraY = 0

generalMethod.mouseVisible = false

function generalMethod.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function generalMethod.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function generalMethod.Rsign()
    return love.math.random(2) == 2 and 1 or -1
end

return generalMethod
