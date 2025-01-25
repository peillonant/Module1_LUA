function Debug_CrossOrigine(objectToDebug)
    local crossOrigine = {}
    crossOrigine.image = love.graphics.newImage("_images/croix.png")
    crossOrigine.ox = crossOrigine.image:getWidth()/2
    crossOrigine.oy = crossOrigine.image:getHeight()/2
    crossOrigine.px = objectToDebug.px
    crossOrigine.py = objectToDebug.py
    return crossOrigine
end

function Debug_DrawCross(objectToDebug)
    return love.graphics.draw(objectToDebug.image, objectToDebug.px, objectToDebug.py, 0, 1, 1, objectToDebug.ox, objectToDebug.oy)
end

function Update_DrawCross(objectToDebug, debugObject)
    debugObject.px = objectToDebug.px
    debugObject.py = objectToDebug.py
end

function Debug_DisplayInfo()
    return   love.graphics.print("Velocity vx="..tostring(Lander.vx).." |  vy="..tostring(Lander.vx), 0 , 0)
end