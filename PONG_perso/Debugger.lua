function Debug_DisplayInfo()
    love.graphics.print("Ball Angle="..tostring(Ball.angle_Deg), 10 , love.graphics.getHeight())
    --print(tostring(Ball.angle_Deg))
end

function Debug_DisplayInfo_BallPosition(textToDisplay)
    print(textToDisplay,tostring(Ball.px), tostring(Ball.py))
end