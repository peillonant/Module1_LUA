-- TODO RETRAVAILLER POUR LE RENDRE PLUS PROPRE AVEC LES BONS REQUIRE

local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")

local menu = {}

menu.canContinue = false

local sprite = {}
sprite.Panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png")
sprite.Button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png")

local textMenu = {
    {text = "New Game", py = -sprite.Button:getHeight() * 3, color = generalMethod.color.default},
    {text = "Continue", py = -sprite.Button:getHeight() * 1.5, color = generalMethod.color.default},
    {text = "Option", py = 0, color = generalMethod.color.default},
    {text = "Credit", py = sprite.Button:getHeight() * 1.5, color = generalMethod.color.default},
    {text = "Quit", py = sprite.Button:getHeight() * 3, color = generalMethod.color.default}
}

local buttonSizeX = 2
local buttonSizeY = 1.25

function menu.UpdateMenu()
    local mousePX, mousePY = love.mouse.getPosition()

    -- Check the position of the mouse to impact the visuel of the menu
    menu.ColorMenuManagement(mousePX, mousePY)
end

local function ConditionMenuPx(mousePX)
    return (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel:getWidth() * buttonSizeX) and
        mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel:getWidth() * buttonSizeX))
end

local function ConditionMenuPY(mousePY, index)
    return (mousePY > ((love.graphics.getHeight() / 2) + textMenu[index].py - sprite.Button:getHeight() / 2)) and
        (mousePY < ((love.graphics.getHeight() / 2) + textMenu[index].py + sprite.Button:getHeight() / 2))
end

function menu.ColorMenuManagement(mousePX, mousePY)
    for i = 1, #textMenu do
        if ConditionMenuPx(mousePX) then
            if ConditionMenuPY(mousePY, i) then
                menu.ColorManager(i, generalMethod.color.mouseOver)
            else
                menu.ColorManager(i, generalMethod.color.default)
            end
        else
            menu.ColorManager(i, generalMethod.color.default)
        end
    end
end

function menu.ColorManager(index, fontColor)
    if ((index ~= 2) or (index == 2 and menu.canContinue)) then
        textMenu[index].color = fontColor
    else
        textMenu[index].color = generalMethod.color.notAvailable
    end
end

function menu.MousePressed(mousePX, mousePY, button)
    if (button == 1) then
        if ConditionMenuPx(mousePX) then
            if ConditionMenuPY(mousePY, 1) then
                print("New Game")
                return sceneState.NEWGAME
            elseif (ConditionMenuPY(mousePY, 2) and menu.canContinue == true) then
                print("Continue")
                return sceneState.GAME
            elseif (ConditionMenuPY(mousePY, 3)) then
                print("Option")
                return sceneState.MENU
            elseif (ConditionMenuPY(mousePY, 4)) then
                print("Credit")
                return sceneState.MENU
            elseif (ConditionMenuPY(mousePY, 5)) then
                love.event.quit()
            else
                print("Out side of the Menu")
                return sceneState.MENU
            end
        else
            print("Out side of the Menu")
            return sceneState.MENU
        end
    end
end

function menu.DrawMenu()
    love.graphics.setFont(generalMethod.textMenu)

    -- Panel behind the Menu
    love.graphics.draw(
        sprite.Panel,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        5,
        5,
        sprite.Panel:getWidth() / 2,
        sprite.Panel:getHeight() / 2
    )

    for i = 1, #textMenu do
        -- Button
        love.graphics.draw(
            sprite.Button,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + textMenu[i].py,
            0,
            buttonSizeX,
            buttonSizeY,
            sprite.Button:getWidth() / 2,
            sprite.Button:getHeight() / 2
        )

        love.graphics.setColor(textMenu[i].color.r, textMenu[i].color.g, textMenu[i].color.b)

        -- Text on the button
        love.graphics.print(
            textMenu[i].text,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + textMenu[i].py,
            0,
            1,
            0.75,
            generalMethod.textMenu:getWidth(textMenu[i].text) / 2,
            generalMethod.textMenu:getHeight(textMenu[i].text) / 2
        )

        -- Go back to the default Color (Maybe can be optimize with push and pull ??)
        love.graphics.setColor(1, 1, 1)
    end
end

function menu.KeyPressed(key)
    if (key == "space" and sceneState.DEBUGGERMODE == true) then
        return sceneState.NEWGAME
    else
        return sceneState.MENU
    end
end

return menu
