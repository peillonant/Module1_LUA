function Rsign()
    return love.math.random(2) == 2 and 1 or -1
end

function Dist(x1, y1, x2, y2)
    return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end

function math.angle(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end
