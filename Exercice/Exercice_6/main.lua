-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local weapon = {}
weapon.currentWeapon = 1
weapon.px = 100
weapon.py = 100

local bullets = {}
bullets.image = love.graphics.newImage("images/full.png")
bullets.speed = 5
bullets.ox = bullets.image:getWidth() / 2
bullets.oy = bullets.image:getHeight() / 2

local timeShooting = 0
local timeShooting_Hybrid = 0
local cptBullets = 0

function ShootPistol()
    AddBullets()
end

function ShootMachineGun(dt)
    if (weapon[weapon.currentWeapon].mode == "Automatic") then
        if (timeShooting == 0) then
            AddBullets()
        end

        timeShooting = timeShooting + dt

        if (timeShooting >= weapon[weapon.currentWeapon].cadence / 60) then
            timeShooting = 0
        end
    elseif (weapon[weapon.currentWeapon].mode == "Burst") then
        if (timeShooting == 0 and cptBullets <= weapon[weapon.currentWeapon].burstBullets) then
            AddBullets()
            cptBullets = cptBullets + 1
        end

        timeShooting = timeShooting + dt

        if (timeShooting >= weapon[weapon.currentWeapon].cadence / 60) then
            timeShooting = 0
        end
    elseif (weapon[weapon.currentWeapon].mode == "Hybrid") then
        if (timeShooting == 0 and cptBullets <= weapon[weapon.currentWeapon].burstBullets) then
            AddBullets()
            cptBullets = cptBullets + 1
        end

        timeShooting = timeShooting + dt
        timeShooting_Hybrid = timeShooting_Hybrid + dt

        if (timeShooting >= weapon[weapon.currentWeapon].cadence / 60) then
            timeShooting = 0
        end

        if (timeShooting_Hybrid >= 2) then
            timeShooting_Hybrid = 0
            cptBullets = 0
        end
    end
end

local pistol = {}
pistol.image = love.graphics.newImage("images/pistol.png")
pistol.cadence = 1
pistol.mode = "Single-Shot"
pistol.shoot = ShootPistol
pistol.cannonPX = 110
pistol.cannonPY = 10

local machinegun = {}
machinegun.image = love.graphics.newImage("images/machinegun.png")
machinegun.cadence = 100
machinegun.mode = "Automatic"
machinegun.shoot = ShootMachineGun
machinegun.cannonPX = 225
machinegun.cannonPY = 40

local machinegun_2 = {}
machinegun_2.image = love.graphics.newImage("images/machinegun.png")
machinegun_2.cadence = 5
machinegun_2.mode = "Burst"
machinegun_2.shoot = ShootMachineGun
machinegun_2.cannonPX = 225
machinegun_2.cannonPY = 40
machinegun_2.burstBullets = 10

local machinegun_3 = {}
machinegun_3.image = love.graphics.newImage("images/machinegun.png")
machinegun_3.cadence = 5
machinegun_3.mode = "Hybrid"
machinegun_3.shoot = ShootMachineGun
machinegun_3.cannonPX = 225
machinegun_3.cannonPY = 40
machinegun_3.burstBullets = 10

function AddBullets()
    local newBullets = {}
    newBullets.px = weapon.px + weapon[weapon.currentWeapon].cannonPX
    newBullets.py = weapon.py + weapon[weapon.currentWeapon].cannonPY

    table.insert(bullets, newBullets)
end

function RemoveBullets()
    if (#bullets > 0) then
        for i = #bullets, 1, -1 do
            if (bullets[i].px > love.graphics.getWidth()) then
                table.remove(bullets, i)
            end
        end
    end
end

function love.load()
    table.insert(weapon, pistol)
    table.insert(weapon, machinegun)
    table.insert(weapon, machinegun_2)
    table.insert(weapon, machinegun_3)
end

function love.update(dt)
    if (love.keyboard.isDown("space") and weapon.currentWeapon > 1) then
        weapon[weapon.currentWeapon].shoot(dt)
    end

    if (#bullets > 0) then
        for i = 1, #bullets do
            bullets[i].px = bullets[i].px + bullets.speed
        end
        RemoveBullets()
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)

    if (#bullets > 0) then
        for i = 1, #bullets do
            if (bullets[i].px > weapon.px) then
                love.graphics.draw(bullets.image, bullets[i].px, bullets[i].py, 0, 1, 1, bullets.ox, bullets.oy)
            end
        end
    end

    if (weapon.currentWeapon == 2) then
        love.graphics.setColor(1, 0, 0)
    elseif (weapon.currentWeapon == 3) then
        love.graphics.setColor(0, 1, 0)
    elseif (weapon.currentWeapon == 4) then
        love.graphics.setColor(0, 0, 1)
    else
        love.graphics.setColor(1, 1, 1)
    end

    love.graphics.draw(weapon[weapon.currentWeapon].image, weapon.px, weapon.py)
end

function love.keypressed(key)
    if (key == "space" and weapon.currentWeapon == 1) then
        weapon[weapon.currentWeapon].shoot()
    end

    if (key == "a") then
        if (weapon.currentWeapon == 1) then
            weapon.currentWeapon = #weapon
        else
            weapon.currentWeapon = weapon.currentWeapon - 1
        end
    end

    if (key == "e") then
        if (weapon.currentWeapon == #weapon) then
            weapon.currentWeapon = 1
        else
            weapon.currentWeapon = weapon.currentWeapon + 1
        end
    end

    if (key == "escape") then
        love.event.quit()
    end
end

function love.keyreleased(key)
    if (key == "space" and weapon.currentWeapon == 3) then
        cptBullets = 0
    end
end
