function CreateBall()
    Ball.width = 15
    Ball.height = 15
    Ball.speed = 1
    Ball.px = love.graphics.getWidth()/2 - Ball.width/2
    Ball.py = love.graphics.getHeight()/2 - Ball.height/2
    Ball.dirx = 0
    Ball.diry = 0
    Ball.trail = {}
end

function LaunchBall()
    Ball.px = love.graphics.getWidth()/2 - Ball.width/2
    Ball.py = love.graphics.getHeight()/2 - Ball.height/2

    Score.difficulty = math.random(1, 10)

    Ball.dirx = DirectionDecider(Score.difficulty)
    Ball.diry = DirectionDecider(Score.difficulty)

    ListeTrail = {}
end


function BallMovement(dt)
    Ball.px = Ball.px + Ball.dirx * Ball.speed
    Ball.py = Ball.py + Ball.diry * Ball.speed
end

function BallTouched(dt)
    -- Check when touching the top of the screen
    if (Ball.py < 2 or (Ball.py > love.graphics.getHeight() - Ball.height)) then
        Ball.diry = Ball.diry * -1
        love.audio.play(SndMur)
    end

    -- Check when touching the left of the screen
    if (Ball.px < Player1.width) then
        if (Ball.py < Player1.py or (Ball.py > (Player1.py + Player1.height))) then
            -- Point for the Player2
            Player2.score = Player2.score + 1
            LaunchBall()
            love.audio.play(SndPerdu)
        else
            Ball.dirx = Ball.dirx * -1
            love.audio.play(SndMur)
        end
    end
        
    if (Ball.px > Player2.px - Player2.width) then
        if (Ball.py < Player2.py or (Ball.py > (Player2.py + Player2.height))) then
            -- Point for the Player1
            Player1.score = Player1.score + 1
            LaunchBall()
            love.audio.play(SndPerdu)
        else
            Ball.dirx = Ball.dirx * -1
            love.audio.play(SndMur)
        end
    end

end

function DirectionDecider(integer)
    local direction = math.random(0, 1)*2-1.
    return integer * direction
end


function DrawBall()
    -- Drawing the Ball
    love.graphics.rectangle("fill", Ball.px, Ball.py, Ball.width, Ball.height)

     
end

