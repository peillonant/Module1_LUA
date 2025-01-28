local gameover = {}

function gameover.LoadGameOver()
end

function gameover.UpdateGameOver(dt)
end

function gameover.DrawGameOver(dt)
    love.graphics.print("GAME OVER", 10, 10)
end

return gameover
