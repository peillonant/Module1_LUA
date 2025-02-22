local generalMethod = require("GeneralMethod")

local settings = {}

settings.effectSound = 1
settings.masterSound = 1

settings.command = {}
settings.command.primary = {
    UP = "z",
    RIGHT = "d",
    DOWN = "s",
    LEFT = "q",
    INTERACT = "e",
    ABILITY = "a",
    ATTACK = "space"
}
settings.command.secondary = {
    UP = "up",
    RIGHT = "right",
    DOWN = "down",
    LEFT = "left"
}

settings.command.keyboardUsed = { "z", "d", "s", "q", "e", "a", "space", "up", "right", "down", "left", "escape"}

-- Variable to know which option menu we are (1 : Command, 2 : Sound)
local currentMenu = 1 

-- Variable linked to the update of the command
local commandChanged = false
local commandChanged_indexTextMenu = 0
local commandChanged_textMenu = nil
local commandChanged_indexKeyboardUsed = 0
local commandChanged_command = nil
local commandChanged_tmp = ""


local sprite = {
    panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png"),
    button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png"),
    buttonPressed = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown_pressed.png"),
    buttonKeyboard = love.graphics.newImage("Asset/Interface/Age_1/image/button_grey_settings.png"),
    buttonKeyboardPressed = love.graphics.newImage("Asset/Interface/Age_1/image/button_grey_settings_pressed.png"),
    buttonSound = love.graphics.newImage("Asset/Interface/Age_1/image/button_grey_info.png")
}

local textMenu = {}

textMenu.button = {
    {text = "Command", px = - sprite.button:getWidth() / 1.75 ,py = -sprite.button:getHeight() * 3, color = generalMethod.color.default, spriteButton = sprite.button},
    {text = "Sound", px = sprite.button:getWidth() / 1.75 ,py = -sprite.button:getHeight() * 3, color = generalMethod.color.default, spriteButton = sprite.button},
    {text = "Back", px = 0 ,py = sprite.button:getHeight() * 4, color = generalMethod.color.default, spriteButton = sprite.button}
}

textMenu.command = {
    {text = "UP", py = -generalMethod.textOptionButton:getHeight("UP") * 4.5, color = generalMethod.color.mouseOver},
    {text = "RIGHT", py = -generalMethod.textOptionButton:getHeight("UP") * 2.75, color = generalMethod.color.mouseOver},
    {text = "DOWN", py = -generalMethod.textOptionButton:getHeight("UP"), color = generalMethod.color.mouseOver},
    {text = "LEFT", py = generalMethod.textOptionButton:getHeight("UP")* 0.75, color = generalMethod.color.mouseOver},
    {text = "INTERACT", py = generalMethod.textOptionButton:getHeight("UP") * 2.5, color = generalMethod.color.mouseOver},
    {text = "ABILITY", py = generalMethod.textOptionButton:getHeight("UP") * 4.25, color = generalMethod.color.mouseOver},
    {text = "ATTACK", py = generalMethod.textOptionButton:getHeight("UP") * 6, color = generalMethod.color.mouseOver}
}
textMenu.command.px = love.graphics.getWidth() / 2 - sprite.button:getWidth()

textMenu.command.primary = {
    {text = "Z", px = 0, py = -generalMethod.textOptionButton:getHeight("UP") * 4.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "D", px = 0, py = -generalMethod.textOptionButton:getHeight("UP") * 2.75, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "S", px = 0, py = -generalMethod.textOptionButton:getHeight("UP"), color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "Q", px = 0, py = generalMethod.textOptionButton:getHeight("UP")* 0.75, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "E", px = 0, py = generalMethod.textOptionButton:getHeight("UP") * 2.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "A", px = 0, py = generalMethod.textOptionButton:getHeight("UP") * 4.25, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "SPACE", px = 0, py = generalMethod.textOptionButton:getHeight("UP") * 6, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard}
}
textMenu.command.secondary = {
    {text = "UP", px = sprite.buttonKeyboard:getWidth() * 1.5, py = -generalMethod.textOptionButton:getHeight("UP") * 4.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "RIGHT", px = sprite.buttonKeyboard:getWidth() * 1.5, py = -generalMethod.textOptionButton:getHeight("UP") * 2.75, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "DOWN", px = sprite.buttonKeyboard:getWidth() * 1.5, py = -generalMethod.textOptionButton:getHeight("UP"), color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard},
    {text = "LEFT", px = sprite.buttonKeyboard:getWidth() * 1.5, py = generalMethod.textOptionButton:getHeight("UP")* 0.75, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonKeyboard}
}

textMenu.sound = {
    {text = "Master Volume", px = love.graphics.getWidth() / 2 - sprite.button:getWidth(), py = -generalMethod.textOptionButton:getHeight("UP") * 4, color = generalMethod.color.mouseOver},
    {text = "Effect Volume", px = love.graphics.getWidth() / 2 - sprite.button:getWidth(), py = generalMethod.textOptionButton:getHeight("UP")* 1.5, color = generalMethod.color.mouseOver}
}

textMenu.sound.command = {
    {text = "+", px = love.graphics.getWidth() / 8, py = - generalMethod.textOptionButton:getHeight(settings.masterSound) * 1.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonSound},
    {text = "-", px = - love.graphics.getWidth() / 8, py = - generalMethod.textOptionButton:getHeight(settings.masterSound) * 1.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonSound},
    {text = "+", px = love.graphics.getWidth() / 8, py = generalMethod.textOptionButton:getHeight(settings.masterSound) * 4.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonSound},
    {text = "-", px = - love.graphics.getWidth() / 8, py = generalMethod.textOptionButton:getHeight(settings.masterSound) * 4.5, color = generalMethod.color.mouseOver, spriteButton = sprite.buttonSound}
}


-------------------- LOCAL FUNCTION LINKED TO CONDTION FOR CLICK ---------------------------

local function ConditionPX (mousePX, localTextMenu, index)
    return (mousePX > ((love.graphics.getWidth() / 2) + localTextMenu[index].px - localTextMenu[index].spriteButton:getWidth() / 2) and 
            mousePX < ((love.graphics.getWidth() / 2) + localTextMenu[index].px + localTextMenu[index].spriteButton:getWidth() / 2))
end

local function ConditionPY (mousePY, localTextMenu, index)
    return (mousePY > ((love.graphics.getHeight() / 2) + localTextMenu[index].py - localTextMenu[index].spriteButton:getHeight() / 2)) and
            (mousePY < ((love.graphics.getHeight() / 2) + localTextMenu[index].py + localTextMenu[index].spriteButton:getHeight() / 2))
end

-------------------------------------------------------------------------------------------

------------------------ LOCAL FUNCTION LINKED TO CHANGE INPUT -----------------------------

-- Function that managed the first step of the change of a command
local function CommandChanged(tabMenuCommand, indexTabMenu, tabSettingsCommand, indexTabKeyboardUsed)

    -- First, we retrieve the value on the value tmp (in case we have to cancel the update)
    commandChanged_indexTextMenu = indexTabMenu
    commandChanged_textMenu = tabMenuCommand
    commandChanged_indexKeyboardUsed = indexTabKeyboardUsed
    commandChanged_command = tabSettingsCommand
    commandChanged_tmp = settings.command.keyboardUsed[indexTabKeyboardUsed]

    -- Second, we remove the value on the tab KeyboardUsed
    settings.command.keyboardUsed[indexTabKeyboardUsed] = ""

    -- Third, we update the button
    tabMenuCommand[indexTabMenu].text = ""
    tabMenuCommand[indexTabMenu].spriteButton = sprite.buttonKeyboardPressed

    commandChanged = true
end


-- Function that managed the change of the command
local function CommandChanged_Input(key)

    -- First, we check if the value is not already on the tab KeyBoardUsed
    for i = 1, #settings.command.keyboardUsed do
        if (settings.command.keyboardUsed[i] == key) then
            return false
        end
    end

    -- Now, we can update the value with the new Input
    commandChanged_textMenu[commandChanged_indexTextMenu].text = string.upper(key)

    settings.command.keyboardUsed[commandChanged_indexKeyboardUsed] = key

    -- Condition IF to change the correct button
    if (commandChanged_indexTextMenu == 1) then
        commandChanged_command.UP = key
    elseif (commandChanged_indexTextMenu == 2) then
        commandChanged_command.RIGHT = key
    elseif (commandChanged_indexTextMenu == 3) then
        commandChanged_command.DOWN = key
    elseif (commandChanged_indexTextMenu == 4) then
        commandChanged_command.LEFT = key
    elseif (commandChanged_indexTextMenu == 5) then
        commandChanged_command.INTERACT = key
    elseif (commandChanged_indexTextMenu == 6) then
        commandChanged_command.ABILITY = key
    elseif (commandChanged_indexTextMenu == 7) then
        commandChanged_command.ATTACK = key
    end

    commandChanged = false
end


-- Function that managed the back to previous value
local function CommandChanged_BackPreviously()

    commandChanged_textMenu[commandChanged_indexTextMenu].text = string.upper(commandChanged_tmp)

    settings.command.keyboardUsed[commandChanged_indexKeyboardUsed] = commandChanged_tmp

    -- Condition IF to change the correct button
    if (commandChanged_indexTextMenu == 1) then
        commandChanged_command.UP = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 2) then
        commandChanged_command.RIGHT = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 3) then
        commandChanged_command.DOWN = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 4) then
        commandChanged_command.LEFT = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 5) then
        commandChanged_command.INTERACT = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 6) then
        commandChanged_command.ABILITY = commandChanged_tmp
    elseif (commandChanged_indexTextMenu == 7) then
        commandChanged_command.ATTACK = commandChanged_tmp
    end


    commandChanged = false
end


-------------------------------------------------------------------------------------------

------------------------ LOCAL FUNCTION LINKED TO DRAWING ---------------------------------

local function DrawButtonSettings()
    for i = 1, #textMenu.button do
        -- Button
        love.graphics.draw(
            textMenu.button[i].spriteButton,
            love.graphics.getWidth() / 2 + textMenu.button[i].px,
            love.graphics.getHeight() / 2 + textMenu.button[i].py,
            0,
            1,
            1.25,
            textMenu.button[i].spriteButton:getWidth() / 2,
            textMenu.button[i].spriteButton:getHeight() / 2
        )

        love.graphics.setColor(textMenu.button[i].color.r, textMenu.button[i].color.g, textMenu.button[i].color.b)

        -- Text on the button
        love.graphics.print(
            textMenu.button[i].text,
            love.graphics.getWidth() / 2 + textMenu.button[i].px,
            love.graphics.getHeight() / 2 + textMenu.button[i].py,
            0,
            1,
            1,
            generalMethod.textOptionButton:getWidth(textMenu.button[i].text) / 2,
            generalMethod.textOptionButton:getHeight(textMenu.button[i].text) / 2
        )

        -- Go back to the default Color (Maybe can be optimize with push and pull ??)
        love.graphics.setColor(1, 1, 1)
    end
end

local function DrawTextCommand()
    for i = 1, #textMenu.command do
        
         -- Button behind the text Primary
         love.graphics.draw(
            textMenu.command.primary[i].spriteButton,
            love.graphics.getWidth() / 2 + textMenu.command.primary[i].px,
            love.graphics.getHeight() / 2 + textMenu.command.primary[i].py,
            0,
            1,
            1,
            sprite.buttonKeyboard:getWidth() / 2,
            sprite.buttonKeyboard:getHeight() / 2
        )

         -- Button behind the text Secondary
        if (i < 5) then
            love.graphics.draw(
                textMenu.command.secondary[i].spriteButton,
                love.graphics.getWidth() / 2 + textMenu.command.secondary[i].px,
                love.graphics.getHeight() / 2 + textMenu.command.secondary[i].py,
                0,
                1,
                1,
                sprite.buttonKeyboard:getWidth() / 2,
                sprite.buttonKeyboard:getHeight() / 2
            )  
        end    
        
        love.graphics.setColor(textMenu.command[i].color.r, textMenu.command[i].color.g, textMenu.command[i].color.b)

        -- Text on the button
        love.graphics.print(
            textMenu.command[i].text,
            textMenu.command.px,
            love.graphics.getHeight() / 2 + textMenu.command[i].py,
            0,
            1,
            1,
            0,
            generalMethod.textOptionButton:getHeight(textMenu.command[i].text) / 2
        )

        -- Text of Primary Command
        love.graphics.print(
            textMenu.command.primary[i].text,
            love.graphics.getWidth() / 2 + textMenu.command.primary[i].px,
            love.graphics.getHeight() / 2 + textMenu.command.primary[i].py,
            0,
            1,
            1,
            generalMethod.textOptionButton:getWidth(textMenu.command.primary[i].text) / 2,
            generalMethod.textOptionButton:getHeight(textMenu.command.primary[i].text) / 2
        )

        -- Text of Secondary Command
        if (i < 5) then
            love.graphics.print(
                textMenu.command.secondary[i].text,
                love.graphics.getWidth() / 2 + textMenu.command.secondary[i].px,
                love.graphics.getHeight() / 2 + textMenu.command.secondary[i].py,
                0,
                1,
                1,
                generalMethod.textOptionButton:getWidth(textMenu.command.secondary[i].text) / 2,
                generalMethod.textOptionButton:getHeight(textMenu.command.secondary[i].text) / 2
            )
        end

        love.graphics.setColor(1, 1, 1)        
    end
end

local function DrawTextSound()
    love.graphics.setColor(0,0,0)
    for i = 1, #textMenu.sound do
        love.graphics.print(
            textMenu.sound[i].text,
            textMenu.sound[i].px,
            love.graphics.getHeight() / 2 + textMenu.sound[i].py,
            0,
            1,
            1,
            0,
            generalMethod.textOptionButton:getHeight(textMenu.sound[i].text) / 2
        )
    end

    love.graphics.print(
        settings.masterSound * 100,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2 - generalMethod.textOptionButton:getHeight(settings.masterSound) * 1.5,
        0,
        1,
        1,
        generalMethod.textOptionButton:getWidth(settings.masterSound * 100) / 2,
        generalMethod.textOptionButton:getHeight(settings.masterSound * 100) / 2
    )
    
    love.graphics.print(
        settings.effectSound * 100,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2 + generalMethod.textOptionButton:getHeight(settings.masterSound) * 4.5,
        0,
        1,
        1,
        generalMethod.textOptionButton:getWidth(settings.effectSound * 100) / 2,
        generalMethod.textOptionButton:getHeight(settings.effectSound * 100) / 2
    )

    for i = 1, #textMenu.sound.command do
        love.graphics.setColor(1,1,1)

        -- Draw button behind text
        love.graphics.draw(
            sprite.buttonSound,
            love.graphics.getWidth() / 2 + textMenu.sound.command[i].px,
            love.graphics.getHeight() / 2 + textMenu.sound.command[i].py,
            0,
            1,
            1,
            sprite.buttonSound:getWidth() / 2,
            sprite.buttonSound:getHeight() / 2
        )

        love.graphics.setColor(0,0,0)

        -- Print the text of button to update sound
        love.graphics.print(
            textMenu.sound.command[i].text,
            love.graphics.getWidth() / 2 + textMenu.sound.command[i].px,
            love.graphics.getHeight() / 2 + textMenu.sound.command[i].py,
            0,
            1,
            1,
            generalMethod.textOptionButton:getWidth(textMenu.sound.command[i].text) / 2,
            generalMethod.textOptionButton:getHeight(textMenu.sound.command[i].text) / 2
        )

        love.graphics.setColor(1,1,1)
    end
end 

-------------------------------------------------------------------------------------------

------------------------ FUNCTION CALLED BY OTHER MODULE ----------------------------------


function settings.UpdateSettings()
    -- Check the current menu to display on the option
    for i = 1, #textMenu.button do
        if (currentMenu == i) then
            textMenu.button[i].color = generalMethod.color.mouseOver
            textMenu.button[i].spriteButton = sprite.buttonPressed
        else
            textMenu.button[i].color = generalMethod.color.default
            textMenu.button[i].spriteButton = sprite.button
        end
    end
end

function settings.DrawSettings()
    love.graphics.setFont(generalMethod.textOptionButton)

    -- Panel behind the Menu
    love.graphics.draw(
        sprite.panel,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        5,
        5,
        sprite.panel:getWidth() / 2,
        sprite.panel:getHeight() / 2
    )

    -- Draw the Button Menu on the top
    DrawButtonSettings()

    -- Draw the text of the Option
    if (currentMenu == 1) then
        DrawTextCommand()
    elseif (currentMenu == 2) then
        DrawTextSound()
    end
end

function settings.MousePressed(mousePX, mousePY, button)
    if (button == 1) then
        -- Check Menu Button Command
        if (ConditionPX (mousePX, textMenu.button, 1)) then       -- Button command
            if (ConditionPY( mousePY, textMenu.button, 1)) then
                if (currentMenu ~= 1) then
                    currentMenu = 1
                end
            end
        elseif (ConditionPX (mousePX, textMenu.button, 2)) then   -- Button Sound
            if (ConditionPY( mousePY, textMenu.button, 2)) then
                if (currentMenu ~= 2) then
                    currentMenu = 2
                end
                if (commandChanged) then
                    CommandChanged_BackPreviously()
                end
            end
        elseif (ConditionPX (mousePX, textMenu.button, 3)) then   -- Button Back
            if (ConditionPY( mousePY, textMenu.button, 3)) then
                
                if (commandChanged) then
                    CommandChanged_BackPreviously()
                end
                
                return false
            end
        end

        -- Check Click on Menu Command
        if (currentMenu == 1 and not commandChanged) then
            if (ConditionPX (mousePX, textMenu.command.primary, 1)) then
                if (ConditionPY (mousePY, textMenu.command.primary, 1)) then
                    CommandChanged(textMenu.command.primary, 1, settings.command.primary, 1)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 2)) then
                    CommandChanged(textMenu.command.primary, 2, settings.command.primary, 2)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 3)) then
                    CommandChanged(textMenu.command.primary, 3, settings.command.primary, 3)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 4)) then
                    CommandChanged(textMenu.command.primary, 4, settings.command.primary, 4)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 5)) then
                    CommandChanged(textMenu.command.primary, 5, settings.command.primary, 5)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 6)) then
                    CommandChanged(textMenu.command.primary, 6, settings.command.primary, 6)
                elseif (ConditionPY (mousePY, textMenu.command.primary, 7)) then
                    CommandChanged(textMenu.command.primary, 7, settings.command.primary, 7)
                end
            elseif (ConditionPX (mousePX, textMenu.command.secondary, 1)) then
                if (ConditionPY (mousePY, textMenu.command.secondary, 1)) then
                    CommandChanged(textMenu.command.secondary, 1, settings.command.secondary, 8)
                elseif (ConditionPY (mousePY, textMenu.command.secondary, 2)) then
                    CommandChanged(textMenu.command.secondary, 2, settings.command.secondary, 9)
                elseif (ConditionPY (mousePY, textMenu.command.secondary, 3)) then
                    CommandChanged(textMenu.command.secondary, 3, settings.command.secondary, 10)
                elseif (ConditionPY (mousePY, textMenu.command.secondary, 4)) then
                    CommandChanged(textMenu.command.secondary, 4, settings.command.secondary, 11)
                end
            end
        end

        -- Check Click on Menu Sound
        if (currentMenu == 2) then
            if (ConditionPY(mousePY, textMenu.sound.command, 1)) then 
                if (ConditionPX (mousePX, textMenu.sound.command, 1)) then
                    settings.masterSound = settings.masterSound + 0.1
                    if (settings.masterSound > 1) then
                        settings.masterSound = 1
                    end
                elseif (ConditionPX (mousePX, textMenu.sound.command, 2)) then
                    settings.masterSound = settings.masterSound - 0.1
                    if (settings.masterSound < 0.1) then
                        settings.masterSound = 0
                    end
                end
            elseif (ConditionPY(mousePY, textMenu.sound.command, 3)) then
                if (ConditionPX (mousePX, textMenu.sound.command, 3)) then
                    settings.effectSound = settings.effectSound + 0.1
                    if (settings.effectSound > 1) then
                        settings.effectSound = 1
                    end
                elseif (ConditionPX (mousePX, textMenu.sound.command, 4)) then
                    settings.effectSound = settings.effectSound - 0.1
                    if (settings.effectSound < 0.1) then
                        settings.effectSound = 0
                    end
                end
            end
        end
    end

    return true
end

function settings.KeyPressed(key)
    if (commandChanged) then
        if (key == "escape") then
            CommandChanged_BackPreviously()
        else
            CommandChanged_Input(key)
        end
    end
    
    if (key == "escape" and not commandChanged) then
        return false 
    else
        return true
    end
end

return settings