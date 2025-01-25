-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf('no')

require("LanderSettings")
require("EngineSettings")
require("Debugger")
require("InputManagerMovement")

Lander = {}
Engine = {}
Debug = {}
Debug.crossOrigine = {}

local debugOn_Lander = false
local debugOn_Engine = false
local debugOn_Info = false

function love.load()
    CreateLander()
    CreateEngine()

    Debug.crossOrigine.lander = Debug_CrossOrigine(Lander)
    Debug.crossOrigine.engine = Debug_CrossOrigine(Engine)
end

function love.update(dt)
    -- Velocity of the gravity
    Lander.vy = Lander.vy + (0.01 *60* dt)
    
    -- Management of the Input and impacting the character
    InputMovement(dt)

    if (debugOn_Lander == true) then
        Update_DrawCross(Lander, Debug.crossOrigine.lander)
    end
    
    if (debugOn_Engine == true) then
        Update_DrawCross(Engine, Debug.crossOrigine.engine)
    end

    Lander.px = Lander.px + Lander.vx
    Lander.py = Lander.py + Lander.vy
end

function love.draw()
    -- draw Lander
    love.graphics.draw(Lander.image, Lander.px, Lander.py, math.rad(Lander.angle), 1, 1, Lander.ox, Lander.oy)

    -- draw Engine
    if (Engine.isOn) then
        love.graphics.draw(Engine.image, Lander.px, Lander.py, math.rad(Lander.angle), 1, 1, Engine.ox, Engine.oy)
    end

    -- draw Debug
    if (debugOn_Lander) then
        Debug_DrawCross(Debug.crossOrigine.lander)
    end

    if (debugOn_Engine) then
        Debug_DrawCross(Debug.crossOrigine.engine)
    end

    if (debugOn_Info) then
        Debug_DisplayInfo()
    end
end

function love.keypressed(key)
    -- Activation / Deactivation debug crossOrigine Lander
    if (love.keyboard.isDown("l") and debugOn_Lander == false) then
        debugOn_Lander = true
    elseif (love.keyboard.isDown("l") and debugOn_Lander) then
        debugOn_Lander = false
    end

    -- Activation / Deactivation debug crossOrigine Engine
    if (love.keyboard.isDown("m") and debugOn_Engine == false) then
        debugOn_Engine = true
    elseif (love.keyboard.isDown("m") and debugOn_Engine) then
        debugOn_Engine = false
    end

    if (love.keyboard.isDown("h") and debugOn_Info == false) then
        debugOn_Info = true
    elseif (love.keyboard.isDown("h") and debugOn_Info) then
        debugOn_Info = false
    end
    
end