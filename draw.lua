local Util  = require "util"
local RGB   = require "rgb"



--MODULE FOR DRAWING STUFF--

local draw = {}

local FONT_FIX_X = 10
local FONT_FIX_Y = 8

-----------------------
--STATE SETUP FUNCTIONS
-----------------------

function draw.setup_setup()
    
    SetupHUD_default("simple")
    
    --Creates textboxes for current players
    Util.updatePlayersB()


    -----------------------------
    --Creates setup buttons
    -----------------------------

    local x, y, w, h, font
    local gap = 5 --Gap between two buttons
    local color_b = COLOR(233, 131, 0)
    local color_t = COLOR(0, 0, 0)

    --N_PLAYERS BUTTON
    x = 300
    y = 20
    w = 60
    h = 60
    font = font_but_m
    
    --Up button
    n_player_up = But(x, y, w, h, "+", font, color_b, color_t,
        function()         
            if N_PLAYERS < MAX_PLAYERS then
                N_PLAYERS = N_PLAYERS + 1
                --Insert new CPU player
                local rgb_b = RGB.randomColor()
                local rgb_h = RGB.randomDarkColor(rgb_b)
                local P   = PLAYER(N_PLAYERS, false, nil, nil, nil, nil, rgb_b, rgb_h, true, 1, nil)
                table.insert(P_T, P)
                Util.updatePlayersB()
            end
        end)
    B_T["n_player_up"] = n_player_up

    --Down button
    n_player_down = But(x, y + h + gap, w, h, "-", font, color_b, color_t,
        function()
            if N_PLAYERS > 1 then
                local p = P_T[N_PLAYERS]
                if p.control == "WASD" then WASD_PLAYER = 0
                elseif p.control == "ARROWS" then ARROWS_PLAYER = 0 end
                table.remove(P_T, N_PLAYERS)

                --Removes player "head box"
                TB_T["P"..p.number.."tb"] = nil
                
                N_PLAYERS = N_PLAYERS - 1
                Util.updatePlayersB()
            end
        end)
    B_T["n_player_down"] = n_player_down

    --BESTOF BUTTON
    x = 700
    y = 20
    w = 60
    h = 60
    font = font_but_m

    --Up button
    bestof_up = But(x, y, w, h, "+", font, color_b, color_t,
        function()   
            BESTOF = BESTOF + 1
        end)
    B_T["bestof_up"] =  bestof_up

    --Down button
    bestof_down = But(x, y + h + gap, w, h, "-", font, color_b, color_t,
        function()
            if BESTOF > 1 then
                BESTOF = BESTOF - 1
            end
        end)
    B_T["bestof_down"] = bestof_down



    -----------------------------
    --Creates setup textbox
    -----------------------------
    
    color_b = COLOR(233, 131, 0)
    color_t = COLOR(0, 0, 0)
    font = font_but_m

    --N_PLAYERS TEXTBOX
    x = 40
    y = 40
    w = 240
    h = 60
    n_player_tb = TB(x, y, w, h, "NUMBER OF PLAYERS", font, color_b, color_t)
    TB_T["n_player_tb"] = n_player_tb

    --BESTOF TEXTBOX
    x = 540
    y = 40
    w = 140
    h = 60
    bestof_tb = TB(x, y, w, h, "BEST OF", font, color_b, color_t)
    TB_T["bestof_tb"] = bestof_tb

    -----------------------------
    --Creates setup text
    -----------------------------

    font = font_reg_m
    x = 400
    y = 700
    color = COLOR(255, 255, 255)
    txt = TXT(x, y, "Press ENTER to start match", font, color)
    TXT_T["start"] = txt
    

end

--Draw game countdown and text
function draw.game_setup()
    
    SetupHUD_default("complete")

    SetupHUD_game()

    if not game_begin then
        SetupPlayerIndicator()
    end

end

--Draw pause effect and text
function draw.pause_setup()
    
    SetupHUD_default("complete")

    SetupHUD_game()

    SetupPlayerIndicator()

    --Creates filter
    local color = COLOR(255, 25, 156, 90)
    local filter = FILTER(color)
    F_T["filter"] = filter

    --Creates draw text
    local font = font_reg_m
    local text = "GAME PAUSED"
    local x = (map_x/2-10) * TILESIZE + BORDER
    local y = (map_y/2) * TILESIZE + BORDER
    color = COLOR(0, 0, 0)
    local txt = TXT(x, y, text, font, color)
    TXT_T["pause"] = txt

end

--Draw gameover effect and text
function draw.gameover_setup()
    
    SetupHUD_default("simple")

    SetupHUD_game()

    local font
    local color, text, x, y, b_color, t_color, filter_color,txt
    local continue_text --text to conitnue match or go back to setup
    local p, tb, filter, winnertext
    y = map_y/2 * TILESIZE + BORDER
    
    continue_text = "Press ENTER to continue"

    --End of match
    if MATCH_BEGIN == false then
        filter_color = COLOR(12, 69, 203, 90)
        text = "THE ULTIMATE CHAMPION IS PLAYER ".. winner .."!!"
        x = (map_x/2-15) * TILESIZE + BORDER
        continue_text = "Press ENTER to go back to setup"

        --Creates a textbox for the champion, right next to the player
        font = font_reg_s
        b_color = COLOR(255, 255, 255, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[winner]
        tb = TB((p.x-2)*TILESIZE + BORDER, (p.y-2)*TILESIZE + BORDER, 5*TILESIZE, TILESIZE, ">>CHAMP1ON<<",font, b_color, t_color)
        TB_T["CHAMPION"] = tb

    --Case of a draw
    elseif winner == 0 then
        filter_color = COLOR(255, 0, 0, 90)
        text = "DRAW!"
        x = (map_x/2-3) * TILESIZE + BORDER
    
    --Case of a single winner
    else
        filter_color = COLOR(12, 69, 203, 90)
        text = "WINNER IS PLAYER " .. winner
        x = (map_x/2-6) * TILESIZE + BORDER

        --Creates a textbox for the winner, right next to the player
        font = font_reg_s
        b_color = COLOR(0, 0, 0, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[winner]
        tb = TB((p.x-2)*TILESIZE + BORDER, (p.y-2)*TILESIZE + BORDER, 5*TILESIZE, TILESIZE, ">>WINNER<<",font, b_color, t_color)
        TB_T["winner"] = tb

    end
    
    --Creates setup filter and textbox
    filter = FILTER(filter_color)
    F_T["filter"] = filter

    font = font_reg_m
    color = COLOR(255, 255, 255)
    txt = TXT(x, y, text, font, color)
    TXT_T["winnertxt"] = txt

    local cont_txt = TXT((map_x-42)*TILESIZE - BORDER, (map_y-5)*TILESIZE + BORDER, continue_text, font, color)
    TXT_T["continue"] = cont_txt

end

----------------------
--STATE DRAW FUNCTIONS
----------------------

--Draw all stuff from setup
function draw.setup_state()
    
    DrawAll()

    --Draw variables
    local font = font_but_m
    love.graphics.setColor( 255, 255, 255)
    love.graphics.setFont(font)
    --N_PLAYERS var
    love.graphics.print(N_PLAYERS, 150, 120, 0, 2, 2)

    --BESTOF var
    love.graphics.print(BESTOF, 600, 120, 0, 2, 2)


end


--Draw all stuff from game
function draw.game_state()

    DrawMap()
    
    DrawScore()
    
    DrawAll()

    if not game_begin then
        DrawCountdown()
    end
end

--Draw all stuff from pause
function draw.pause_state()
    
    DrawMap()
    
    DrawScore()
    
    DrawAll()

end

--Draw all stuff from gameover
function draw.gameover_state()
    
    DrawMap()

    DrawScore()
    
    DrawAll()

end


----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable from tables
function DrawAll()
    

    DrawB()

    DrawPB()

    DrawPART()

    DrawF()

    DrawTXT()

    DrawTB()

end


--Draws all default textboxes
function DrawTB()
    
    for i, v in pairs(TB_T) do
        drawTextBox(v)
    end

end

--Draw all default buttons
function DrawB()

    for i, v in pairs(B_T) do
        drawButton(v)
    end

end

--Draw all default texts
function DrawTXT()

    for i, v in pairs(TXT_T) do
        drawText(v)
    end

end

--Draw all filters
function DrawF()

    for i, v in pairs(F_T) do
        drawFilter(v)
    end

end

--Draw all players buttons
function DrawPB()
   
    for i, v in pairs(PB_T) do
        drawButton(v)
    end
end

--Draw all particles
function DrawPART()
   
    for i, v in pairs(PART_T) do
        drawParticle(v)
    end
end

--Draw a given button
function drawButton(button)
    
    --Draws button box
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b, button.b_color.a)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    
    local fwidth  = button.font:getWidth( button.text) --Width of font
    local fheight = button.font:getHeight(button.text) --Height of font
    local tx = (button.w - fwidth)/2                   --Relative x position of font on textbox
    local ty = (button.h - fheight)/2                  --Relative y position of font on textbox

    --Draws button text
    local font = font_but_m
    love.graphics.setColor(button.t_color.r, button.t_color.g, button.t_color.b, button.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

--Draw a given textbox
function drawTextBox(textbox)
    
    --Draws textbox box
    love.graphics.setColor(textbox.b_color.r, textbox.b_color.g, textbox.b_color.b, textbox.b_color.a)
    love.graphics.rectangle("fill", textbox.x, textbox.y, textbox.w, textbox.h)
    
    local fwidth  = textbox.font:getWidth( textbox.text) --Width of font
    local fheight = textbox.font:getHeight(textbox.text) --Height of font
    local tx = (textbox.w - fwidth)/2                    --Relative x position of font on textbox
    local ty = (textbox.h - fheight)/2                   --Relative y position of font on textbox

    --Draws textbox text
    local font = textbox.font
    love.graphics.setColor(textbox.t_color.r, textbox.t_color.g, textbox.t_color.b, textbox.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(textbox.text, textbox.x + tx , textbox.y + ty)

end

--Draw a given text
function drawText(text)

    --Draws text
    local font = text.font
    love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
    love.graphics.setFont(font)
    love.graphics.print(text.text, text.x, text.y)

end

function drawFilter(filter)

    love.graphics.setColor(filter.color.r, filter.color.g, filter.color.b, filter.color.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

end

function drawParticle(particle)
    local r = 3
    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)
    love.graphics.circle("fill", particle.x*TILESIZE + BORDER, particle.y * TILESIZE + BORDER, r)

end

--------------------
--MAP DRAW FUNCTIONS
--------------------

--Draws the game map
function DrawMap()

    DrawGrid()

    DrawHeads()

end

--Draws the map and players bodies
function DrawGrid()

    --Draw the tiles with the corresponding color
    for i=1,map_x do
        for j=1,map_y do

            local number = map[i][j] --Number of that tile (0 for map or else for player number)
            if number == 0 then
                love.graphics.setColor(map_color.r, map_color.g, map_color.b)
            else
                love.graphics.setColor(P_T[number].b_color.r, P_T[number].b_color.g, P_T[number].b_color.b)
            end

            love.graphics.rectangle("fill", (i-1)*TILESIZE + BORDER, (j-1)*TILESIZE + BORDER, TILESIZE, TILESIZE) --Draw tile            
        end
    end
end

--Draws players heads
function DrawHeads()
    
    --Draw players heads
    for i, v in ipairs(P_T) do
        
        --Checks if head is dead
        local dead = 1
        if v.dead then dead = 0 end

        --Draws heads
        love.graphics.setColor(v.h_color.r * dead, v.h_color.g * dead , v.h_color.b * dead)

        love.graphics.rectangle("fill", (v.x-1)*TILESIZE + BORDER, (v.y-1)*TILESIZE + BORDER, TILESIZE, TILESIZE) --Draw tile     
    end
end

--------------------
--HUD DRAW FUNCTIONS
--------------------

--Toggles DEBUG
function draw.toggleDebug()
    
    if not DEBUG then 
        local font = font_reg_s
        local color = COLOR(255, 255, 255)
        local DEBUG_TEXT = TXT(150, love.graphics.getHeight() - 2* TILESIZE, "DEBUG ON", font, color)
        TXT_T["DEBUG"] = DEBUG_TEXT
        DEBUG = true
    else
        TXT_T["DEBUG"] = nil
        DEBUG = false
    end

end

--Draw the default HUD
function SetupHUD_default(mode)
    
    local text, txt
    local font = font_reg_s
    local color = COLOR(255, 255, 255)
    
    
    --set text according to mode
    if mode == "simple" then
        text = "(q)uit"
    elseif mode == "complete" then
        text = "(q)uit        (p)ause"
    end

    --commands text
    txt = TXT(0, love.graphics.getHeight() - 2* TILESIZE, text, font, color)
    TXT_T["commands"] = txt

    --DEBUG text
    if DEBUG then
        font = font_reg_s
        color = COLOR(255, 255, 255)
        local DEBUG_TEXT = TXT(150, love.graphics.getHeight() - 2* TILESIZE, "DEBUG ON", font, color)
        TXT_T["DEBUG"] = DEBUG_TEXT
    end

end

--Draw the game HUD
function SetupHUD_game()

    local text, x, y, label, txt
    local font = font_reg_s
    local color = COLOR(255, 255, 255)

    --Score Text
    txt = TXT(80, 20, "SCORE:", font, color)
    TXT_T["SCOREtxt"] = txt

    --Best Of Text
    txt = TXT(100 + #P_T*45 + 80, 20, "BEST OF:", font, color)
    TXT_T["BESTOFtxt"] = txt

    --Each player indicator
    for i, p in ipairs(P_T) do
        x = 100 + 45*p.number
        y = 5
        text = "P"..p.number
        label = text.."score"
        txt = TXT(x, y, text, font, color)
        TXT_T[label] = txt
    end

end


---------------------------------
--PLAYER INDICATOR DRAW FUNCTIONS
---------------------------------

--Draw players indicator
function SetupPlayerIndicator()
    local font = font_reg_s
    local color = COLOR(255, 255, 255)
    
    for i, p in ipairs(P_T) do
        --Creates player indicator text
        local label = "player"..p.number.."txt"
        local txt = TXT((p.x-1)*TILESIZE + BORDER, (p.y-5)*TILESIZE + BORDER, "P" .. p.number, font, color)
        TXT_T[label] = txt

        --Creates players control/CPU text
        if  p.control == "WASD" then
            label = "WASD"
            txt = TXT((p.x-2)*TILESIZE + 1 + BORDER, (p.y-3)*TILESIZE + BORDER, "WASD", font, color)
        elseif p.control == "ARROWS" then
            label = "ARROWS"
            txt = TXT((p.x-2)*TILESIZE - 1 + BORDER, (p.y-3)*TILESIZE + BORDER, "ARROWS", font, color)
        else
            label = "CPU"..i
            txt = TXT((p.x-1)*TILESIZE - 4 + BORDER, (p.y-3)*TILESIZE + BORDER, "CPU", font, color)
        end
        TXT_T[label] = txt
    end
end

----------------------
--OTHER DRAW FUNCTIONS
----------------------

--Draw countdown in the beggining of every match
function DrawCountdown()
    love.graphics.setColor(184, 184, 234)
    love.graphics.setFont(font_reg_m)
    love.graphics.print(countdown, map_x/2 * TILESIZE + BORDER, (map_y/2-5) * TILESIZE + BORDER, 0, 2, 2)
end

--Draw all players score
function DrawScore()
    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font_reg_s)    
    
    --Draw players score
    for i, p in ipairs(P_T) do
        love.graphics.print(p.score, 100 + 45*p.number, 20, 0, 1.2, 1.2)
    end

    --Draw Best of
    love.graphics.print(BESTOF, 100 + #P_T*45 + 140, 19, 0, 1.2, 1.2)
end

--Return functions
return draw
