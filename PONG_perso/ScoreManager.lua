function CreateScore()
    Score.difficulty = 0
    Score.font = love.graphics.newFont(20)

    love.graphics.setLineWidth( 2 )
end

function PrintScore()
    love.graphics.setFont(Score.font)

    local witdh_score = love.graphics.getFont():getWidth(Player1.score)
    local witdh_difficulty = love.graphics.getFont():getWidth(Score.difficulty)

    love.graphics.print(tostring(Player1.score), love.graphics.getWidth()/2 - 20 - witdh_score, 10)
    love.graphics.print(tostring(Player2.score), love.graphics.getWidth()/2 + 20, 10)

    love.graphics.line(love.graphics.getWidth() / 2, 0, love.graphics.getWidth() / 2, love.graphics.getHeight())

    love.graphics.print("Point difficulty "..tostring(Score.difficulty), 50, 5)
end