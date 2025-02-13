local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")
local myMenu = require("Menu/MenuManager")

local pauseMenu = {}

local buttonSizeX = 1.5
local buttonSizeY = 1.25

local sprite = {}
sprite.Panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png")
sprite.Button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png")

local textMenu = {
    {text = "Resume", py = -sprite.Button:getHeight() * 2, color = generalMethod.color.default},
    {text = "Option", py = -sprite.Button:getHeight() * 0.5, color = generalMethod.color.default},
    {text = "Exit to Menu", py = sprite.Button:getHeight(), color = generalMethod.color.default},
    {text = "Exit to Desktop", py = sprite.Button:getHeight() * 2.5, color = generalMethod.color.default}
}

local function ConditionMenuPX(mousePX)
    return (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel:getWidth() * buttonSizeX) and
        mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel:getWidth() * buttonSizeX))
end

local function ConditionMenuPY(mousePY, index)
    return (mousePY > ((love.graphics.getHeight() / 2) + textMenu[index].py - sprite.Button:getHeight() / 2)) and
        (mousePY < ((love.graphics.getHeight() / 2) + textMenu[index].py + sprite.Button:getHeight() / 2))
end

local function ColorMenuManagement(mousePX, mousePY)
    for i = 1, #textMenu do
        if ConditionMenuPX(mousePX) then
            if ConditionMenuPY(mousePY, i) then
                textMenu[i].color = generalMethod.color.mouseOver
            else
                textMenu[i].color = generalMethod.color.default
            end
        else
            textMenu[i].color = generalMethod.color.default
        end
    end
end

function pauseMenu.MousePressed(mousePX, mousePY, button, game)
    if (button == 1) then
        if ConditionMenuPX(mousePX) then
            if (ConditionMenuPY(mousePY, 1)) then
                print("Resume")
                game.UdaptePause()

                generalMethod.mouseVisible = not generalMethod.mouseVisible
                love.mouse.setVisible(generalMethod.mouseVisible)

                return sceneState.GAME
            elseif (ConditionMenuPY(mousePY, 2)) then
                print("Option")
                return sceneState.GAME
            elseif (ConditionMenuPY(mousePY, 3)) then
                print("Exit to Menu")
                myMenu.canContinue = true
                game.UdaptePause()
                return sceneState.MENU
            elseif (ConditionMenuPY(mousePY, 4)) then
                print("Exit to Desktop")
                love.event.quit()
            else
                print("Out side of the Menu")
                return sceneState.GAME
            end
        else
            print("Out side of the Menu")
            return sceneState.GAME
        end
    end
end

function pauseMenu.UpdatePauseMenu(GameManager)
    local mousePX, mousePY = love.mouse.getPosition()

    -- Check the position of the mouse to impact the visuel of the menu
    ColorMenuManagement(mousePX, mousePY)
end

function pauseMenu.DrawPauseMenu()
    -- Create a filter on the Game
    love.graphics.setColor(0, 0, 0, .5)

    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(1, 1, 1, 1)

    -- Create the Menu
    -- Panel behind the Menu
    love.graphics.draw(
        sprite.Panel,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        3.5,
        3.5,
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
        love.graphics.setFont(generalMethod.textPause)

        -- Text on the button
        love.graphics.print(
            textMenu[i].text,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + textMenu[i].py,
            0,
            1,
            1,
            generalMethod.textPause:getWidth(textMenu[i].text) / 2,
            generalMethod.textPause:getHeight(textMenu[i].text) / 2
        )

        -- Go back to the default Color (Maybe can be optimize with push and pull ??)
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(generalMethod.DefaultFont)
    end
end

return pauseMenu
