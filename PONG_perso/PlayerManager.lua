function CreatePlayer(indexPlayer)
    local player = {}
    player.width = 10
    player.height = 125
    player.speed = 250
    player.score = 0

    if (indexPlayer == 1) then
        player.px = 5
        player.py = 0
    else
        player.px = love.graphics.getWidth() - player.width - 5
        player.py = love.graphics.getHeight() - player.height
    end

    player.limit = love.graphics.getHeight() - player.height

    return player

end

function DrawPlayer(player)
    love.graphics.rectangle("fill", player.px, player.py, player.width, player.height)
end