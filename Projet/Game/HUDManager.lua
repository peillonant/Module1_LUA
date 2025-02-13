local generalMethod = require("GeneralMethod")
local myCharact = require("Game/CharacterManager")
local mySprite = require("Game/SpriteManager")
local myArmory = require("Entities/Armory")
local myBonus = require("Entities/Bonus")

local HUD = {}

local panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png")
local button = love.graphics.newImage("Asset/Interface/Age_1/image/button_grey_info.png")

local buttonSizeX = 2
local buttonSizeY = 1.25

-- Function to Compute and Draw the time of the Cooldown
local function CooldownDisplay(px, canUse, timer, cooldown)
    px = px - generalMethod.TILE_WIDTH
    local py = love.graphics.getHeight() - generalMethod.TILE_HEIGHT

    local alpha = 0
    local height = -generalMethod.TILE_HEIGHT * 2

    if (canUse == false) then
        if (timer < cooldown) then
            local ratio = timer / cooldown
            alpha = 1.25 - ratio
            height = height * ratio
        end
    end

    love.graphics.setColor(1, 1, 1, alpha)

    love.graphics.rectangle("fill", px, py, generalMethod.TILE_WIDTH * 2, height)

    love.graphics.setColor(1, 1, 1, 1)
end

-- Function to Draw the rectangle around the icone
local function CooldownRectangle(px, py)
    px = px - generalMethod.TILE_WIDTH
    py = py - generalMethod.TILE_HEIGHT
    love.graphics.rectangle("line", px, py, generalMethod.TILE_WIDTH * 2, generalMethod.TILE_HEIGHT * 2)
end

-- Function to Draw the frame of the Heart
local function DrawFrameHeart(frameQuad, px, py)
    love.graphics.draw(
        mySprite.HUD.charactHealth.TileSheet,
        frameQuad,
        px,
        py,
        0,
        1,
        1,
        generalMethod.TILE_WIDTH / 2,
        generalMethod.TILE_HEIGHT / 2
    )
end

local function DrawHeart()
    local nbHeart = myCharact.hpMax
    local nbHeartFull = math.floor(myCharact.hp / 2)
    local nbHeartHalf = math.floor(myCharact.hp % 2)

    local px = 0
    local pxLine = 0
    local py = generalMethod.TILE_HEIGHT

    -- display the number of Heart on the top left of the screen
    for i = 1, math.ceil(nbHeart / 2) do
        if (i > 5) then
            py = generalMethod.TILE_HEIGHT * 2
            pxLine = 5
        end

        px = generalMethod.TILE_WIDTH + ((i - 1 - pxLine) * generalMethod.TILE_WIDTH)

        -- First we draw the contour of the heart
        local frameQuad = mySprite.HUD.charactHealth.frame[4]
        DrawFrameHeart(frameQuad, px, py)

        -- We draw the back of the heart
        frameQuad = mySprite.HUD.charactHealth.frame[3]
        DrawFrameHeart(frameQuad, px, py)

        -- Now we draw the Full Heart
        if (i <= nbHeartFull) then
            frameQuad = mySprite.HUD.charactHealth.frame[1]
        elseif (nbHeartHalf > 0) then -- Now we draw the Half Heart
            frameQuad = mySprite.HUD.charactHealth.frame[2]
            nbHeartHalf = nbHeartHalf - 1
        end
        DrawFrameHeart(frameQuad, px, py)
    end
end

local function DrawInfo()
    local px = generalMethod.TILE_WIDTH - generalMethod.TILE_WIDTH / 2
    local py = generalMethod.TILE_HEIGHT * 3 -- Multiply by 3 to be under the display of Heart

    local text = nil

    love.graphics.setFont(generalMethod.HUDInfoFont)

    -- First Display : Coin
    text = "Coin: " .. tostring(myCharact.nbCoin)
    love.graphics.print(text, px, py)

    -- Second Display: DMG
    py = py + generalMethod.HUDInfoFont:getHeight(text) * 1.5
    text = "DMG: " .. tostring(myCharact.weapon.dmg)
    love.graphics.print(text, px, py)

    -- Third Display: CoolDown ATK
    py = py + generalMethod.HUDInfoFont:getHeight(text) * 1.5
    text = "CoolDown: " .. tostring(myCharact.weapon.dmg)
    love.graphics.print(text, px, py)

    -- Five Display : Charact Speed
    py = py + generalMethod.HUDInfoFont:getHeight(text) * 1.5
    text = "Speed: " .. tostring(myCharact.speed)
    love.graphics.print(text, px, py)

    -- Forth Display : Range
    if (myCharact.weapon.type ~= myArmory.typeWeapon.CLOSE) then
        py = py + generalMethod.HUDInfoFont:getHeight(text) * 1.5
        text = "Range: " .. tostring(myCharact.weapon.range)
        love.graphics.print(text, px, py)
    end

    love.graphics.setFont(generalMethod.DefaultFont)
end

local function DrawATKIcone()
    local px = generalMethod.TILE_WIDTH * 2
    local py = love.graphics.getHeight() - generalMethod.TILE_HEIGHT * 2

    -- Draw the Icon of the Weapon
    local frameQuad = mySprite.charact.bullets.frame[1]
    love.graphics.draw(
        mySprite.charact.bullets.TileSheet,
        frameQuad,
        px,
        py,
        0,
        2,
        2,
        generalMethod.TILE_WIDTH / 2,
        generalMethod.TILE_HEIGHT / 2
    )

    -- Draw the rectangle around the Weapon
    CooldownRectangle(px, py)

    -- Draw the Cooldown of the Weapon
    CooldownDisplay(px, myCharact.canATK, myCharact.timerAttack, myCharact.weapon.cooldown)
end

local function DrawABLIcone()
    local px = generalMethod.TILE_WIDTH * 4.5
    local py = love.graphics.getHeight() - generalMethod.TILE_HEIGHT * 2

    -- Draw the Icon of the Weapon
    if (myCharact.weapon.abilities ~= nil) then
        local frameQuad = mySprite.charact.bullets.frame[1]
        love.graphics.draw(
            mySprite.charact.bullets.TileSheet,
            frameQuad,
            px,
            py,
            0,
            1,
            1,
            generalMethod.TILE_WIDTH / 2,
            generalMethod.TILE_HEIGHT / 2
        )
    end

    -- Draw the rectangle around the Weapon
    CooldownRectangle(px, py)

    -- Draw the Cooldown of the Weapon
    if (myCharact.weapon.abilities ~= nil) then
        CooldownDisplay(px, myCharact.canABL, myCharact.timerAbility, myCharact.weapon.abilities.cooldown)
    end
end

local function DrawMiniMap()
    local px = love.graphics.getWidth() - generalMethod.TILE_WIDTH * 5
    local py = love.graphics.getHeight() - generalMethod.TILE_HEIGHT * 5

    -- Draw the Icon of the Weapon
    love.graphics.rectangle("line", px, py, generalMethod.TILE_WIDTH * 4, generalMethod.TILE_HEIGHT * 4)

    love.graphics.print("MINI-MAP", px, py)
end

function HUD.DrawHUD()
    DrawHeart()
    DrawInfo()
    DrawATKIcone()
    --DrawABLIcone()
    --DrawMiniMap()
end

-- Function called by LevelManager to draw the Information regarding the Object
function HUD.DrawInfoBullItem(bonusItem)
    love.graphics.setColor(1, 1, 1, 0.85)

    local panelPX = bonusItem.px - (panel:getWidth() / 2) - (generalMethod.TILE_WIDTH / 2)
    local panelPY = bonusItem.py - panel:getHeight() - (generalMethod.TILE_HEIGHT / 2)

    love.graphics.draw(panel, panelPX, panelPY, 0, 1, 1)

    love.graphics.setColor(0, 0, 0, 1)

    local textInfo = {}

    -- Retrieve information to display regarding the type of the item
    if (bonusItem.type == myBonus.type.WEAPON) then
        textInfo = {
            "Type: " .. tostring(bonusItem.weapon.type),
            "Dmg: " .. tostring(bonusItem.weapon.dmg),
            "Cooldown: " .. tostring(bonusItem.weapon.cooldown)
        }

        if (bonusItem.weapon.type ~= myArmory.typeWeapon.CLOSE) then
            textInfo[4] = "Range: " .. tostring(bonusItem.weapon.range)
        end
    else
        textInfo = {
            "Name: " .. tostring(bonusItem.item.name),
            "Buff: " .. tostring(bonusItem.item.buff)
        }
    end

    -- Draw the text regarding the item
    love.graphics.setFont(generalMethod.ItemInfoFont)

    for i = 1, #textInfo do
        local px = panelPX + 5
        local py = panelPY + generalMethod.ItemInfoFont:getHeight(textInfo[i]) * ((i - 1) * 1.15) + 7.5
        love.graphics.print(textInfo[i], px, py)
    end

    -- Draw the button Interact with

    love.graphics.setColor(1, 1, 1)

    local buttonPX = panelPX + (panel:getWidth() / 2) - (button:getWidth() / 4)
    local buttonPY = panelPY + panel:getHeight() - (button:getHeight() / 4)
    love.graphics.draw(button, buttonPX, buttonPY, 0, 0.5, 0.5)

    love.graphics.setColor(0, 0, 0)

    local textPX = buttonPX + (button:getWidth() / 4) - generalMethod.ItemInfoFont:getWidth("E") / 2
    local textPY = buttonPY + (button:getHeight() / 4) - generalMethod.ItemInfoFont:getHeight("E") / 2

    love.graphics.print("E", textPX, textPY)

    love.graphics.setColor(1, 1, 1)

    love.graphics.setFont(generalMethod.DefaultFont)
end

return HUD
