local generalMethod = require("GeneralMethod")

local credits = {}

local sprite = {
    panel = love.graphics.newImage("Asset/Interface/Age_1/image/panel_beige.png"),
    button = love.graphics.newImage("Asset/Interface/Age_1/image/button_brown.png"),
    panel_titre = love.graphics.newImage("Asset/Interface/Age_1/image/panel_titre_brown.png")
}

local textCredit = {}

textCredit.button = {
    {text = "BACK", px = 0 ,py = sprite.button:getHeight() * 6, color = generalMethod.color.default, spriteButton = sprite.button}
}

textCredit.text = {
    {text = "CREDITS", px = 0, py = -generalMethod.textMenu:getHeight("UP") * 7.5},
    {text = "DEVELOPER:", px = 0, py = -generalMethod.textMenu:getHeight("UP") * 5},
    {text = "Antoine \"Slayjug\" Peillon", px = 0, py = -generalMethod.textMenu:getHeight("UP") * 3},
    {text = "ACKNOWLEDGEMENTS:", px = 0,  py = generalMethod.textMenu:getHeight("UP") * 0.5},
    {text = "Fabien Nouaillat", px = 0,  py = generalMethod.textMenu:getHeight("UP") * 2},
    {text = "Jordan Debruyne", px = 0,  py = generalMethod.textMenu:getHeight("UP") * 3.5}
}

function credits.DrawCredits()

    -- Panel behind the Menu
    love.graphics.draw(
        sprite.panel,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        0,
        7.5,
        7.5,
        sprite.panel:getWidth() / 2,
        sprite.panel:getHeight() / 2
    )

    -- Panel Bheind the Title
    love.graphics.draw(
        sprite.panel_titre,
        love.graphics.getWidth() / 2 + textCredit.text[1].px,
        love.graphics.getHeight() / 2 + textCredit.text[1].py,
        0,
        3,
        1.5,
        sprite.panel_titre:getWidth() / 2,
        sprite.panel_titre:getHeight() / 2
    )


    love.graphics.setFont(generalMethod.textMenu)

    for i = 1 , #textCredit.text do  
        if (i == 1) then
            love.graphics.setColor(1,1,1)
        else
            love.graphics.setColor(0,0,0)
        end

        love.graphics.print(
            textCredit.text[i].text,
            love.graphics.getWidth() / 2 + textCredit.text[i].px,
            love.graphics.getHeight() / 2 + textCredit.text[i].py,
            0,
            1,
            1,
            generalMethod.textMenu:getWidth(textCredit.text[i].text) / 2,
            generalMethod.textMenu:getHeight(textCredit.text[i].text) / 2
        )
    end

    love.graphics.setColor(1,1,1)

    love.graphics.setFont(generalMethod.textOptionButton)

    love.graphics.draw(
        sprite.button,
        love.graphics.getWidth() / 2 + textCredit.button[1].px,
        love.graphics.getHeight() / 2 + textCredit.button[1].py,
        0,
        1,
        1.25,
        textCredit.button[1].spriteButton:getWidth() / 2,
        textCredit.button[1].spriteButton:getHeight() / 2
    )

    love.graphics.print(
        textCredit.button[1].text,
        love.graphics.getWidth() / 2 + textCredit.button[1].px,
        love.graphics.getHeight() / 2 + textCredit.button[1].py,
        0,
        1,
        1,
        generalMethod.textOptionButton:getWidth(textCredit.button[1].text) / 2,
        generalMethod.textOptionButton:getHeight(textCredit.button[1].text) / 2
    )

end

function credits.MousePressed(mousePX, mousePY, button)
    if (button == 1) then
        if  (mousePX > ((love.graphics.getWidth() / 2) + textCredit.button[1].px - sprite.button:getWidth() / 2) and 
              mousePX < ((love.graphics.getWidth() / 2) + textCredit.button[1].px + sprite.button:getWidth() / 2)) then         
            if (mousePY > ((love.graphics.getHeight() / 2) + textCredit.button[1].py - sprite.button:getHeight() / 2)) and
                (mousePY < ((love.graphics.getHeight() / 2) + textCredit.button[1].py + sprite.button:getHeight() / 2)) then
                return false
            else
                return true
            end
        else
            return true
        end
    end
end

function credits.KeyPressed(key)
    if (key == "escape") then
        return false 
    else
        return true
    end
end

return credits