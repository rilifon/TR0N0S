--MODULE FOR DRAWING STUFF--

local draw = {}

local FONT_FIX_X = 10
local FONT_FIX_Y = 8

--Draw all buttons
function draw.setup()
    --Draw all buttons
    for i, v in ipairs(B_T) do
        drawButton(v)
    end

    --Draw all textboxes
    for i, v in ipairs(TB_T) do
        drawTextBox(v)
    end

    --Draw variables
    local font = font_but_m
    love.graphics.setColor( 255, 255, 255)
    love.graphics.setFont(font)
    --MAX PLAYERS var
    love.graphics.print(MAX_PLAYERS, 150, 120, 0, 2, 2)


end

function drawButton(button)
    --Draws button box
    love.graphics.setColor(233, 131, 0)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    
    local fwidth  = button.font:getWidth( button.text)
    local fheight = button.font:getHeight(button.text)
    local tx = (button.w - fwidth)/2
    local ty = (button.h - fheight)/2

    --Draws button text
    local font = font_but_m
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

function drawTextBox(textbox)
    --Draws textbox box
    love.graphics.setColor(233, 131, 0)
    love.graphics.rectangle("fill", textbox.x, textbox.y, textbox.w, textbox.h)
    
    local fwidth  = textbox.font:getWidth( textbox.text)
    local fheight = textbox.font:getHeight(textbox.text)
    local tx = (textbox.w - fwidth)/2
    local ty = (textbox.h - fheight)/2

    --Draws textbox text
    local font = font_but_m
    love.graphics.setColor( 0, 0, 0 )
    love.graphics.setFont(font)
    love.graphics.print(textbox.text, textbox.x + tx , textbox.y + ty)

end

--Draws the game map
function draw.map()

    drawMap()

    drawHeads()

end

function drawMap()
    
    --Draw the tiles with the corresponding color
    for i=1,map_x do
        for j=1,map_y do

            if map[i][j] == 0 then
                love.graphics.setColor( 166, 216, 74  )
            elseif map[i][j] == 1 then
                love.graphics.setColor( 233, 131, 0   )
            elseif map[i][j] == 2 then
                love.graphics.setColor( 125, 0  , 99  )
            elseif map[i][j] == 3 then
                love.graphics.setColor( 237, 26 , 55  )
            elseif map[i][j] == 4 then
                love.graphics.setColor( 155, 155, 155 )
            end
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE) --Draw tile            
        end
    end
end

function drawHeads()
    
    --Draw players heads
    for i=1,MAX_PLAYERS do
        
        --Checks if head is dead
        local dead = 1
        if players[i].dead then dead = 0 end

        --Draws heads
        if     i == 1 then
            love.graphics.setColor(255*dead, 161*dead , 30 *dead)
        elseif i == 2 then
            love.graphics.setColor(255*dead, 30* dead , 129*dead)
        elseif i == 3 then
            love.graphics.setColor(255*dead, 56* dead , 85* dead)
        elseif i == 4 then
            love.graphics.setColor(185*dead, 185*dead , 185*dead)
        end

        love.graphics.rectangle("fill", players[i].x*TILESIZE, players[i].y*TILESIZE, TILESIZE, TILESIZE) --Draw tile     
    end
end

--Draw the game HUD
function draw.HUD()
    love.graphics.setFont(font_reg_s)
    love.graphics.setColor(255, 255, 255)
    love.graphics.print("(q)uit        (p)ause", 0, (map_y+1)*TILESIZE)
    
    if DEBUG then
        love.graphics.print("DEBUG ON", 150, (map_y+1)*TILESIZE)
    end
end

--Draw gameover effect and text
function draw.gameover()
    
    --Case of a draw
    if winner == 0 then
        love.graphics.setColor(255, 0, 0,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        love.graphics.setColor(0, 0, 0)
        love.graphics.print( "DRAW!", 20, 300, 0, 2, 2)
    
    --Case of a single winner
    else
        love.graphics.setColor(12, 69, 203,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(0, 0, 0)
        love.graphics.print( "WINNER IS PLAYER " .. winner, 20, 300, 0, 2, 2)
    end
end

--Draw pause effect and text
function draw.pause()
    love.graphics.setFont(font_reg_m)
    love.graphics.setColor(255, 255, 255,90)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(0, 0, 0)
    love.graphics.print( "GAME PAUSED", 20, 300, 0, 2, 2)
end

--Draw players indicator
function draw.playerIndicator()
    love.graphics.setFont(font_reg_s)
    for i=1,map_x do
        for j=1,map_y do
            for k=1,MAX_PLAYERS do
                if players[k].x == i and players[k].y == j then
                    love.graphics.setColor(0, 0, 0)
                    love.graphics.print("P" .. k, i*TILESIZE, (j-2)*TILESIZE)
                    if     k == 1 then
                        love.graphics.print("WASD", (i-1)*TILESIZE + 1, (j-1)*TILESIZE)
                    elseif k == 2 then
                        love.graphics.print("ARROWS", (i-1)*TILESIZE - 1, (j-1)*TILESIZE)
                    end
                end
            end
        end
    end
end

--Draw countdown in the beggining of every match
function draw.countdown()
    love.graphics.setColor(0, 0, 0)
    love.graphics.setFont(font_reg_m)
    love.graphics.print(countdown, map_x/2 * TILESIZE, map_y/2 * TILESIZE, 0, 2, 2)
end


--Return functions
return draw
