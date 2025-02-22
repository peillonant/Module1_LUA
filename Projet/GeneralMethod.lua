local generalMethod = {}

generalMethod.DEFAULTSCALE = 2

generalMethod.TILE_HEIGHT = 32
generalMethod.TILE_WIDTH = 32

generalMethod.WORLDWIDTH = 512
generalMethod.WORLDHEIGHT = 384

generalMethod.DefaultFont = love.graphics.getFont()
generalMethod.HUDInfoFont = love.graphics.newFont(17.5)
generalMethod.ItemInfoFont = love.graphics.newFont(11.5)
generalMethod.ItemInfoFontSmaller = love.graphics.newFont(9)
generalMethod.textMenu = love.graphics.setNewFont(30)
generalMethod.textPause = love.graphics.setNewFont(20)
generalMethod.textOptionButton = love.graphics.setNewFont(17.5)
generalMethod.textTitle = love.graphics.setNewFont(40)

generalMethod.color = {}
generalMethod.color.default = {r = 1, g = 1, b = 1}
generalMethod.color.mouseOver = {r = 0, g = 0, b = 0}
generalMethod.color.notAvailable = {r = 0.75, g = 0.75, b = 0.75}
generalMethod.color.title = {r = 0.60, g= 0.41, b= 0.13}

generalMethod.currentLevel = 1
generalMethod.currentRoom = 1

generalMethod.maxLevel = 1

generalMethod.cameraX = 0
generalMethod.cameraY = 0

generalMethod.mouseVisible = true

function generalMethod.InitVariable()
    generalMethod.currentLevel = 1
    generalMethod.currentRoom = 1

    generalMethod.cameraX = 0
    generalMethod.cameraY = 0
end

function generalMethod.dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function generalMethod.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

function generalMethod.Rsign()
    return love.math.random(2) == 2 and 1 or -1
end

-- Collision detection function;
-- Returns true if two boxes overlap, false if they don't;
-- x1,y1 are the top-left coords of the first box, while w1,h1 are its width and height;
-- x2,y2,w2 & h2 are the same, but for the second box.
function generalMethod.CheckCollision(x1,y1, x2,y2 )
  return x1 < x2+ generalMethod.TILE_WIDTH and
         x2 < x1+ generalMethod.TILE_WIDTH and
         y1 < y2+ generalMethod.TILE_HEIGHT and
         y2 < y1+ generalMethod.TILE_HEIGHT
end

return generalMethod
