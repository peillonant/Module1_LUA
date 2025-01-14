function InputMovement(dt)
    -- Moving the pads Player1
    if (love.keyboard.isDown("z") and Player1.py > 0) then 
        Player1.py = Player1.py - (Player1.speed * dt)
    end
        
    if (love.keyboard.isDown("s") and Player1.py < (love.graphics.getHeight() - Player1.height)) then
        Player1.py = Player1.py + (Player1.speed * dt)
    end

    -- Moving the pads Player2
    if (love.keyboard.isDown("up") and Player2.py > 0) then 
        Player2.py = Player2.py - (Player2.speed * dt)
    end
        
    if (love.keyboard.isDown("down") and Player2.py < (love.graphics.getHeight() - Player2.height)) then
        Player2.py = Player2.py + (Player2.speed * dt)
    end
end