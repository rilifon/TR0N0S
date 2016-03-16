--MODULE FOR DRAWING STUFF--

local draw = {}

local FONT_FIX_X = 10
local FONT_FIX_Y = 8

--Draw all buttons
function draw.setup()
    --Draw all default buttons
    for i, v in ipairs(B_T) do
        drawButton(v)
    end

    --Draw all default textboxes
    for i, v in ipairs(DTB_T) do
        drawTextBox(v)
    end

    --Draw all players buttons
    for i, v in ipairs(PB_T) do
        drawButton(v)
    end

    --Draw variables
    local font = font_but_m
    love.graphics.setColor( 255, 255, 255)
    love.graphics.setFont(font)
    --N PLAYERS var
    love.graphics.print(N_PLAYERS, 150, 120, 0, 2, 2)


end

function drawButton(button)
    --Draws button box
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    
    local fwidth  = button.font:getWidth( button.text) --Width of font
    local fheight = button.font:getHeight(button.text) --Height of font
    local tx = (button.w - fwidth)/2                   --Relative x position of font on textbox
    local ty = (button.h - fheight)/2                  --Relative y position of font on textbox

    --Draws button text
    local font = font_but_m
    love.graphics.setColor(button.t_color.r, button.t_color.g, button.t_color.b)
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

function drawTextBox(textbox)
    --Draws textbox box
    love.graphics.setColor(textbox.b_color.r, textbox.b_color.g, textbox.b_color.b)
    love.graphics.rectangle("fill", textbox.x, textbox.y, textbox.w, textbox.h)
    
    local fwidth  = textbox.font:getWidth( textbox.text) --Width of font
    local fheight = textbox.font:getHeight(textbox.text) --Height of font
    local tx = (textbox.w - fwidth)/2                    --Relative x position of font on textbox
    local ty = (textbox.h - fheight)/2                   --Relative y position of font on textbox

    --Draws textbox text
    local font = textbox.font
    love.graphics.setColor(textbox.t_color.r, textbox.t_color.g, textbox.t_color.b)
    love.graphics.setFont(font)
    love.graphics.print(textbox.text, textbox.x + tx , textbox.y + ty)

end

--Draws the game map
function draw.map()

    drawMap()

    drawHeads()

end

--Draws the map and players bodies
function drawMap()
    
    --Draw the tiles with the corresponding color
    for i=1,map_x do
        for j=1,map_y do

            local number = map[i][j] --Number of that tile (0 for map or else for player number)
            if number == 0 then
                love.graphics.setColor( 166, 216, 74  )
            else
                love.graphics.setColor(P_T[number].b_color.r, P_T[number].b_color.g, P_T[number].b_color.b)
            end

            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE) --Draw tile            
        end
    end
end

--Draws players heads
function drawHeads()
    
    --Draw players heads
    for i, v in ipairs(P_T) do
        
        --Checks if head is dead
        local dead = 1
        if v.dead then dead = 0 end

        --Draws heads
        love.graphics.setColor(v.h_color.r * dead, v.h_color.g * dead , v.h_color.b * dead)

        love.graphics.rectangle("fill", v.x*TILESIZE, v.y*TILESIZE, TILESIZE, TILESIZE) --Draw tile     
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
    love.graphics.setColor(0, 0, 0)
    
    for i, p in ipairs(P_T) do
        love.graphics.print("P" .. p.number, p.x*TILESIZE, (p.y-2)*TILESIZE)
        if  p.control == "WASD" then
            love.graphics.print("WASD", (p.x-1)*TILESIZE + 1, (p.y-1)*TILESIZE)
        elseif p.control == "ARROWS" then
            love.graphics.print("ARROWS", (p.x-1)*TILESIZE - 1, (p.y-1)*TILESIZE)
        end
    end
end

--Draws the winner of the match
function draw.winner()
    for i, v in ipairs(DTB_T) do
        drawTextBox(v)
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
