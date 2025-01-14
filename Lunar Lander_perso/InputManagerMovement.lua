function InputMovement(dt)
    -- Moving up the lander
    if (love.keyboard.isDown("z") or love.keyboard.isDown("up")) then
        Engine.isOn = true

        -- Calcul the force
        local angle_rad = math.rad(Lander.angle)
        local force_x = math.cos(angle_rad) * Lander.speed * dt
        local force_y = math.sin(angle_rad) * Lander.speed * dt

        -- Update the velocity
        Lander.vx = Lander.vx + force_x
        Lander.vy = Lander.vy + force_y
    else
        Engine.isOn = false
    end

    -- Rotation of the lander
    if (love.keyboard.isDown("q") or love.keyboard.isDown("left")) then
        Lander.angle = Lander.angle - (90 * dt)
    end
    if (love.keyboard.isDown("d") or love.keyboard.isDown("right")) then
        Lander.angle = Lander.angle + (90 * dt)
    end
end