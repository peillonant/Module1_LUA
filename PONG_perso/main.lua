-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

require("BallManager")
require("PlayerManager")
require("ScoreManager")
require("InputManager")
require("Debugger")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

Player1 = {}
Player2 = {}
Ball = {}
Score = {}

ListeTrail = {}

function love.load()
    -- Initialize of all elements
    Player1 = CreatePlayer(1)
    Player2 = CreatePlayer(2)
    CreateBall()
    CreateScore()

    -- Launch the Ball
    LaunchBall()

    SndMur = love.audio.newSource("Ressource/mur.wav", "static")
    SndPerdu = love.audio.newSource("Ressource/perdu.wav", "static")
end

function love.update(dt)
    -- Managing Input Player
    InputMovement(dt)

    -- Update Ball Movement Velocity
    BallMovement(dt)

    -- Update Ball when touching something
    BallTouched(dt)

end

function love.draw()
    -- Drawing the ball of the PONG
    DrawBall()

    -- Drawing the player
    DrawPlayer(Player1)
    DrawPlayer(Player2)

    -- Drawing Score and the screen delimiter
    PrintScore()
end

function love.keypressed(key)
end
