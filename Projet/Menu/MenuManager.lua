local generalMethod = require("GeneralMethod")
local sceneState = require("MAE/SceneState")
local myAudio = require("Game/AudioManager")
local mySettings = require("Menu/SettingsManager")
local myCredits = require("Menu/CreditsManager")

local menu = {}

menu.canContinue = false
menu.optionMenu = false
menu.creditsMenu = false

local sprite = {}
sprite.Panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_Menu.png")
sprite.Button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png")

local textTitle = {
    {text = "EraShift", px = love.graphics.getWidth() / 2, py = 112, color = generalMethod.color.default}
}

local textMenu = {
    {text = "New Game",  py = -sprite.Button:getHeight() * 2.5,       color = generalMethod.color.default},
    {text = "Continue",  py = -sprite.Button:getHeight(),             color = generalMethod.color.default},
    {text = "Options",   py = sprite.Button:getHeight() * 0.5,        color = generalMethod.color.default},
    {text = "Credits",   py = sprite.Button:getHeight() * 2,          color = generalMethod.color.default},
    {text = "Quit",      py = sprite.Button:getHeight() * 3.5,        color = generalMethod.color.default}
}

local buttonSizeX = 2
local buttonSizeY = 1.25

------------------------ LOCAL FUNCTION  ----------------------------------

-- Function that managed the check for the Position of the Mouse on PX
local function ConditionMenuPx(mousePX)
    return (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel:getWidth() * buttonSizeX) and
        mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel:getWidth() * buttonSizeX))
end

-- Function that managed the check for the Position of the Mouse on PY
local function ConditionMenuPY(mousePY, index)
    return (mousePY > ((love.graphics.getHeight() / 2) + textMenu[index].py - sprite.Button:getHeight() / 2)) and
        (mousePY < ((love.graphics.getHeight() / 2) + textMenu[index].py + sprite.Button:getHeight() / 2))
end

-- Function to change the color of the text on the menu
local function ColorManager(index, fontColor)
    if ((index ~= 2) or (index == 2 and menu.canContinue)) then
        textMenu[index].color = fontColor
    else
        textMenu[index].color = generalMethod.color.notAvailable
    end
end

-- Function that managed the check position and trigger the Color change
local function ColorMenuManagement(mousePX, mousePY)
    for i = 1, #textMenu do
        if ConditionMenuPx(mousePX) then
            if ConditionMenuPY(mousePY, i) then
                ColorManager(i, generalMethod.color.mouseOver)
            else
                ColorManager(i, generalMethod.color.default)
            end
        else
            ColorManager(i, generalMethod.color.default)
        end
    end
end

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------

-- Function called by the GameManager Update
function menu.UpdateMenu()
    local mousePX, mousePY = love.mouse.getPosition()

    myAudio.musicVolume = 0.9

    if (menu.optionMenu == false) then
        -- Check the position of the mouse to impact the visuel of the menu
        ColorMenuManagement(mousePX, mousePY)
    elseif (menu.optionMenu == true) then
        mySettings.UpdateSettings(mousePX, mousePY)
    end
end

-- Function called by the GameManager DrawMenu
function menu.DrawMenu()
    if (menu.optionMenu == false and menu.creditsMenu == false) then
    
        
        -- Panel behind the Menu
        love.graphics.draw(
            sprite.Panel,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2,
            0,
            1.5,
            1.5,
            sprite.Panel:getWidth() / 2,
            sprite.Panel:getHeight() / 2
        )

        love.graphics.setFont(generalMethod.textTitle)
        love.graphics.setColor(0.11, 0.07, 0.12)

        love.graphics.print(
            textTitle[1].text,
            textTitle[1].px,
            textTitle[1].py,
            0,
            1,
            1,
            generalMethod.textTitle:getWidth(textTitle[1].text) / 2,
            generalMethod.textTitle:getHeight(textTitle[1].text) / 2
        )

        love.graphics.setColor(1,1,1)
        love.graphics.setFont(generalMethod.textMenu)
        
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
                1,
                generalMethod.textMenu:getWidth(textMenu[i].text) / 2,
                generalMethod.textMenu:getHeight(textMenu[i].text) / 2
            )

            -- Go back to the default Color (Maybe can be optimize with push and pull ??)
            love.graphics.setColor(1, 1, 1)
        end

    elseif (menu.optionMenu == true) then
        mySettings.DrawSettings()
    elseif (menu.creditsMenu == true) then
        myCredits.DrawCredits()
    end
end

-- Function called by the GameManager MousePressed
function menu.MousePressed(mousePX, mousePY, button)
    if (menu.optionMenu == false and menu.creditsMenu == false) then
        if (button == 1) then
            if ConditionMenuPx(mousePX) then
                if ConditionMenuPY(mousePY, 1) then
                    print("[MenuManager] New Game")
                    generalMethod.mouseVisible = false
                    return sceneState.NEWGAME
                elseif (ConditionMenuPY(mousePY, 2) and menu.canContinue == true) then
                    print("[MenuManager] Continue")
                    generalMethod.mouseVisible = false
                    return sceneState.GAME
                elseif (ConditionMenuPY(mousePY, 3)) then
                    print("[MenuManager] Options")
                    generalMethod.mouseVisible = true
                    menu.optionMenu = true
                    return sceneState.MENU
                elseif (ConditionMenuPY(mousePY, 4)) then
                    print("[MenuManager] Credits")
                    generalMethod.mouseVisible = true
                    menu.creditsMenu = true
                    return sceneState.MENU
                elseif (ConditionMenuPY(mousePY, 5)) then
                    love.event.quit()
                else
                    print("[MenuManager] Out side of the Menu")
                    generalMethod.mouseVisible = true
                    return sceneState.MENU
                end
            else
                print("[MenuManager] Out side of the Menu")
                generalMethod.mouseVisible = true
                return sceneState.MENU
            end
        else
            print("[MenuManager] Other Button pressed")
            generalMethod.mouseVisible = true
            return sceneState.MENU
        end
    elseif (menu.optionMenu == true) then
        menu.optionMenu = mySettings.MousePressed(mousePX, mousePY, button)
        return sceneState.MENU
    elseif (menu.creditsMenu == true) then
        menu.creditsMenu = myCredits.MousePressed(mousePX, mousePY, button)
        return sceneState.MENU
    end
end

-- Function called by the GameManager KeyPressed
function menu.KeyPressed(key)
    if (key == "escape" and menu.optionMenu == false and menu.creditsMenu == false) then
        love.event.quit()
    end

    if (menu.optionMenu == true) then
        menu.optionMenu = mySettings.KeyPressed(key)
    elseif (menu.creditsMenu == true) then
        menu.creditsMenu = myCredits.KeyPressed(key)
    end
end

return menu
