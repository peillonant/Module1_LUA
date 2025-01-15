-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

Board = {}
Letters = {"A", "B", "C", "D", "E", "F", "G", "H"}

-- Note: Central point of the chess is Board[5][4] !!

function CreateBoard(sizeSquare)
    Board.sizeSquare = sizeSquare
    Board.center_x = love.graphics.getWidth()/2
    Board.center_y = love.graphics.getHeight()/2
    for i = 1, 8 do -- i = col
        Board[i] = {}
        for j = 1, 8 do -- j = line
            Board[i][j] = {}
            Board[i][j].col = j
            Board[i][j].line =  Letters[i]

            Board[i][j].color = ColorTile(i, j)
            
            Board[i][j].px = ComputePositionX(i)

            Board[i][j].py = ComputePositionY(j) 
        end
    end
end

function ColorTile(i, j)
    local num = i + j
    local color = {}
    if (num % 2 == 0) then
        color.R = 255
        color.G = 0
        color.B = 0
        color.name = "red"
    else
        color.R = 0
        color.G = 0
        color.B = 255
        color.name = "blue"
    end
    return color
end

function ComputePositionX(index)
    local pos

    -- Allow the program to understand where the tile regarding the center
    if (index == 1) then
        pos = Board.center_x - (Board.sizeSquare * 4)
    elseif (index == 2) then
        pos = Board.center_x - (Board.sizeSquare * 3)
    elseif (index == 3) then
        pos = Board.center_x - (Board.sizeSquare * 2)
    elseif (index == 4) then
        pos = Board.center_x - (Board.sizeSquare * 1)
    elseif (index == 5) then
        pos = Board.center_x
    elseif (index == 6) then
        pos = Board.center_x + (Board.sizeSquare * 1)
    elseif (index == 7) then
        pos = Board.center_x + (Board.sizeSquare * 2)
    elseif (index == 8) then
        pos = Board.center_x + (Board.sizeSquare * 3)
    end 

    return pos
end

function ComputePositionY(index)
    local pos

    -- Allow the program to understand where the tile regarding the center
    if (index == 1) then
        pos = Board.center_y + (Board.sizeSquare * 3)
    elseif (index == 2) then
        pos = Board.center_y + (Board.sizeSquare * 2)
    elseif (index == 3) then
        pos = Board.center_y + (Board.sizeSquare * 1)
    elseif (index == 4) then
        pos = Board.center_y
    elseif (index == 5) then
        pos = Board.center_y - (Board.sizeSquare * 1)
    elseif (index == 6) then
        pos = Board.center_y - (Board.sizeSquare * 2)
    elseif (index == 7) then
        pos = Board.center_y - (Board.sizeSquare * 3)
    elseif (index == 8) then
        pos = Board.center_y - (Board.sizeSquare * 4)
    end 

    return pos
end

function DrawPosition()
    for line = 1,8 do
        for col = 1,8 do
            love.graphics.setColor(1,1,1)
            love.graphics.print(Board[line][col].line..Board[line][col].col, Board[line][col].px+25, Board[line][col].py+25)
        end
    end
end

function RetrievePositionPawn(s_Letter, position)
    return (position + Board.sizeSquare/2 - Font:getWidth(s_Letter))
end

function DrawnPawn(index)
    -- pawn
    for i = 1,8 do
        love.graphics.print("P", RetrievePositionPawn("P", Board[i][index].px), RetrievePositionPawn("P", Board[i][index].py))
    end

    if (index == 2) then 
        index = 1
    else
        index = 8
    end

    -- Rook R
        love.graphics.print("R", RetrievePositionPawn("R", Board[1][index].px), RetrievePositionPawn("R", Board[1][index].py))
        love.graphics.print("R", RetrievePositionPawn("R", Board[8][index].px), RetrievePositionPawn("R", Board[8][index].py))
    -- Knight N
        love.graphics.print("N", RetrievePositionPawn("N", Board[2][index].px), RetrievePositionPawn("N", Board[2][index].py))
        love.graphics.print("N", RetrievePositionPawn("N", Board[7][index].px), RetrievePositionPawn("N", Board[7][index].py))
    -- Bishop B
        love.graphics.print("B", RetrievePositionPawn("B", Board[3][index].px), RetrievePositionPawn("B", Board[3][index].py))
        love.graphics.print("B", RetrievePositionPawn("B", Board[6][index].px), RetrievePositionPawn("B", Board[6][index].py))
    -- Queen Q
        love.graphics.print("Q", RetrievePositionPawn("Q", Board[4][index].px), RetrievePositionPawn("Q", Board[4][index].py))
    -- King K
        love.graphics.print("K", RetrievePositionPawn("K", Board[5][index].px), RetrievePositionPawn("K", Board[5][index].py))
end

function ComputeWhichLine(position)
    local rest = (position - Board.center_y) / Board.sizeSquare
    return 4 - math.floor(rest)
end

function ComputeWhichCol(position)
    local rest = (position - Board.center_x) / Board.sizeSquare
    return 5 + math.floor(rest)
end

function love.load()
    CreateBoard(70)

    Font = love.graphics.newFont(18)
    love.graphics.setFont(Font)

end

function love.update(dt)
end

function love.mousepressed(mx, my, mbutton)
    if mbutton == 1 then -- check the Left click 
        if (( (mx < Board.center_x + (Board.sizeSquare*4)) and mx > Board.center_x - (Board.sizeSquare * 4) ) 
            and ((my < Board.center_y + (Board.sizeSquare*4)) and my > Board.center_y - (Board.sizeSquare * 4)))then
                local line = ComputeWhichLine(my)
                local col = ComputeWhichCol(mx)

                print(Board[col][line].line, Board[col][line].col)
        else
            print("Click outside of the board wit the coordonate of => "..tostring(mx).." / "..tostring(my))
        end
    end
end

function love.draw()
    -- Drawing the Boardgame
    for i = 1,8 do
        for j = 1,8 do
            love.graphics.setColor(Board[i][j].color.R, Board[i][j].color.G, Board[i][j].color.B)
            love.graphics.rectangle("fill", Board[i][j].px, Board[i][j].py, Board.sizeSquare, Board.sizeSquare)
        end
    end

    --DrawPosition()
    
    -- First manage the display of Black pawn   
    love.graphics.setColor(0,0,0)
    -- To drawing all piece of a side send the index of the pawn's line
    DrawnPawn(7)

    love.graphics.setColor(1,1,1)
    DrawnPawn(2)
end

function love.keypressed(key)
end
