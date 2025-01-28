local menu = {}

local sceneState

local sprite = {}
sprite.Panel = {}
sprite.Panel[1] = {
    love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/panel_beigeLight.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/panel_blue.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/panel_brown.png")
}

sprite.Button = {}
sprite.Button[1] = {
    love.graphics.newImage("Asset/Interface/Age_1/image/button_beige.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_beige_pressed.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_blue.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_blue_pressed.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_brown_pressed.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_grey.png"),
    love.graphics.newImage("Asset/Interface/Age_1/image/button_grey_pressed.png")
}

local font = {}
font.default = love.graphics.getFont()
font.textMenu = love.graphics.setNewFont(20)
font.color = {}
font.color.default = {r = 1, g = 1, b = 1}
font.color.mouseOver = {r = 0, g = 0, b = 0}
font.color.notAvailable = {r = 0.5, g = 0.5, b = 0.5}

local textMenu = {
    {text = "New Game", py = -sprite.Button[1][1]:getHeight() * 3, color = font.color.default},
    {text = "Continue", py = -sprite.Button[1][1]:getHeight() * 1.5, color = font.color.default},
    {text = "Option", py = 0, color = font.color.default},
    {text = "Credit", py = sprite.Button[1][1]:getHeight() * 1.5, color = font.color.default},
    {text = "Quit", py = sprite.Button[1][1]:getHeight() * 3, color = font.color.default}
}

local canContinue = false

function menu.InitMenu(localSceneState)
    -- Retrieve the module of SceneState to be used on the UpdateMenu
    sceneState = localSceneState
end

function menu.UpdateMenu()
    local mousePX, mousePY = love.mouse.getPosition()

    -- Check the position of the mouse to impact the visuel of the menu
    menu.ColorMenuManagement(mousePX, mousePY)
end

function menu.ColorMenuManagement(mousePX, mousePY)
    for i = 1, #textMenu do
        if
            (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel[1][1]:getWidth() * DEFAULTSCALE) and
                mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel[1][1]:getWidth() * DEFAULTSCALE))
         then
            if
                (mousePY > ((love.graphics.getHeight() / 2) + textMenu[i].py - sprite.Button[1][5]:getHeight() / 2)) and
                    (mousePY < ((love.graphics.getHeight() / 2) + textMenu[i].py + sprite.Button[1][5]:getHeight() / 2))
             then
                menu.ColorManager(i, font.color.mouseOver)
            else
                menu.ColorManager(i, font.color.default)
            end
        else
            menu.ColorManager(i, font.color.default)
        end
    end
end

function menu.ColorManager(index, fontColor)
    if ((index ~= 2) or (index == 2 and canContinue)) then
        textMenu[index].color = fontColor
    else
        textMenu[index].color = font.color.notAvailable
    end
end

function menu.MousePressed(mousePX, mousePY, button)
    if (button == 1) then
        for i = 1, #textMenu do
            if
                (mousePX > ((love.graphics.getWidth() / 2) - sprite.Panel[1][1]:getWidth() * DEFAULTSCALE) and
                    mousePX < ((love.graphics.getWidth() / 2) + sprite.Panel[1][1]:getWidth() * DEFAULTSCALE))
             then
                if
                    (mousePY > ((love.graphics.getHeight() / 2) + textMenu[i].py - sprite.Button[1][5]:getHeight() / 2)) and
                        (mousePY <
                            ((love.graphics.getHeight() / 2) + textMenu[i].py + sprite.Button[1][5]:getHeight() / 2))
                 then
                    if (i == 1) then
                        return sceneState.GAME
                    elseif (i == 2 and canContinue) then
                        return sceneState.GAME
                    elseif (i == 3) then
                    elseif (i == 4) then
                    elseif (i == 5) then
                        love.event.quit()
                    end
                end
            end
        end
    end
end

function menu.DrawMenu()
    love.graphics.setFont(font.textMenu)

    -- Panel behind the Menu
    love.graphics.draw(
        sprite.Panel[1][1],
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        5,
        5,
        sprite.Panel[1][1]:getWidth() / 2,
        sprite.Panel[1][1]:getHeight() / 2
    )

    for i = 1, #textMenu do
        -- Button
        love.graphics.draw(
            sprite.Button[1][5],
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + textMenu[i].py,
            0,
            2,
            1,
            sprite.Button[1][5]:getWidth() / 2,
            sprite.Button[1][5]:getHeight() / 2
        )

        love.graphics.setColor(textMenu[i].color.r, textMenu[i].color.g, textMenu[i].color.b)

        -- Text on the button
        love.graphics.print(
            textMenu[i].text,
            love.graphics.getWidth() / 2,
            love.graphics.getHeight() / 2 + textMenu[i].py,
            0,
            1.5,
            1,
            font.textMenu:getWidth(textMenu[i].text) / 2,
            font.textMenu:getHeight(textMenu[i].text) / 2
        )

        -- Go back to the default Color (Maybe can be optimize with push and pull ??)
        love.graphics.setColor(1, 1, 1)
    end
end

return menu
