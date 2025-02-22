local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")
local myMenu = require("Menu/MenuManager")
local mySettings = require("Menu/SettingsManager")

local pauseMenu = {}

pauseMenu.optionMenu = false


local buttonSizeX = 1.5
local buttonSizeY = 1.25

local sprite = {}
sprite.Panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png")
sprite.Button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png")

local textMenu = {
    {text = "Resume", py = -sprite.Button:getHeight() * 2, color = generalMethod.color.default},
    {text = "Options", py = -sprite.Button:getHeight() * 0.5, color = generalMethod.color.default},
    {text = "Exit to Menu", py = sprite.Button:getHeight(), color = generalMethod.color.default},
    {text = "Exit to Desktop", py = sprite.Button:getHeight() * 2.5, color = generalMethod.color.default}
}

------------------------ LOCAL FUNCTION  ----------------------------------

-- Function that managed the check for the Position of the Mouse on PX
local function ConditionMenuPX(mousePX)
    return (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel:getWidth() * buttonSizeX) and
        mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel:getWidth() * buttonSizeX))
end

-- Function that managed the check for the Position of the Mouse on PY
local function ConditionMenuPY(mousePY, index)
    return (mousePY > ((love.graphics.getHeight() / 2) + textMenu[index].py - sprite.Button:getHeight() / 2)) and
        (mousePY < ((love.graphics.getHeight() / 2) + textMenu[index].py + sprite.Button:getHeight() / 2))
end

-- Function to change the color of the text on the menu
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

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function called by the GameManager Update
function pauseMenu.UpdatePauseMenu()
    local mousePX, mousePY = love.mouse.getPosition()

    if (pauseMenu.optionMenu == false) then
        -- Check the position of the mouse to impact the visuel of the menu
        ColorMenuManagement(mousePX, mousePY)
    elseif (pauseMenu.optionMenu == true) then
        mySettings.UpdateSettings(mousePX, mousePY)
    end
end

-- Function called by the GameManager DrawMenu
function pauseMenu.DrawPauseMenu()
    if (pauseMenu.optionMenu == false) then
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
    elseif (pauseMenu.optionMenu == true) then
        mySettings.DrawSettings()
    end
end

-- Function called by the GameManager MousePressed
function pauseMenu.MousePressed(mousePX, mousePY, button, game)
    if (pauseMenu.optionMenu == false) then
        if (button == 1) then
            if ConditionMenuPX(mousePX) then
                if (ConditionMenuPY(mousePY, 1)) then
                    print("[PauseMenu] Resume")
                    game.UdaptePause()
                    generalMethod.mouseVisible = false
                    sceneState.currentState = sceneState.GAME
                elseif (ConditionMenuPY(mousePY, 2)) then
                    print("[PauseMenu] Option")
                    generalMethod.mouseVisible = true
                    sceneState.currentState = sceneState.GAME
                    pauseMenu.optionMenu = true
                elseif (ConditionMenuPY(mousePY, 3)) then
                    print("[PauseMenu] Exit to Menu")
                    generalMethod.mouseVisible = true
                    myMenu.canContinue = true
                    game.UdaptePause()
                    sceneState.currentState = sceneState.MENU
                elseif (ConditionMenuPY(mousePY, 4)) then
                    print("[PauseMenu] Exit to Desktop")
                    love.event.quit()
                else
                    print("[PauseMenu] Out side of the Menu")
                    generalMethod.mouseVisible = true
                    sceneState.currentState = sceneState.GAME
                end
            else
                print("[PauseMenu] Out side of the Menu")
                generalMethod.mouseVisible = true
                sceneState.currentState = sceneState.GAME
            end
        end
    elseif (pauseMenu.optionMenu == true) then
        pauseMenu.optionMenu = mySettings.MousePressed(mousePX, mousePY, button)
    end
end 

-- Function called by the GameManager KeyPressed
function pauseMenu.KeyPressed(key)
    if (pauseMenu.optionMenu == true) then
        pauseMenu.optionMenu = mySettings.KeyPressed(key)
    end
end

return pauseMenu
