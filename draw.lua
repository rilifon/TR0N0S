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
    local x, y, w, h, font, txt, text, transp, color
    local rgb_b, rgb_h, P 
    local gap --Gap between two buttons
    local color_b, color_t
    
    SetupHUD_default("simple")
    
    --Creates textboxes for current players
    Util.updatePlayersB()

    -----------------------------
    --Creates setup buttons
    -----------------------------

    gap = 5
    color_b = COLOR(233, 131, 0)
    color_t = COLOR(0, 0, 0)

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
                rgb_b = RGB.randomColor()
                rgb_h = RGB.randomDarkColor(rgb_b)
                P   = PLAYER(N_PLAYERS, false, nil, nil, nil, nil, rgb_b, rgb_h, true, 1, nil)
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

    --GOAL BUTTON
    x = 600
    y = 20
    w = 60
    h = 60
    font = font_but_m

    --Up button
    goal_up = But(x, y, w, h, "+", font, color_b, color_t,
        function()   
            GOAL = GOAL + 1
        end)
    B_T["goal_up"] =  goal_up

    --Down button
    goal_down = But(x, y + h + gap, w, h, "-", font, color_b, color_t,
        function()
            if GOAL > 1 then
                GOAL = GOAL - 1
            end
        end)
    B_T["goal_down"] = goal_down



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

    --GOAL TEXTBOX
    x = 440
    y = 40
    w = 140
    h = 60
    goal_tb = TB(x, y, w, h, "GOAL", font, color_b, color_t)
    TB_T["goal_tb"] = goal_tb

    -----------------------------
    --Creates setup text
    -----------------------------

    font = font_reg_m
    text = "Press ENTER to start match"
    y = love.graphics.getHeight() - font:getHeight(text) - 5
    color = COLOR(255, 255, 255)
    transp = COLOR(0, 0, 0, 0)
    tb = TB(0, y, love.graphics.getWidth(), font:getHeight(text), text, font, transp,color)
    TB_T["start"] = tb
    

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
    local color, filter, x, y, font, text, transp, tb
    
    SetupHUD_default("complete")

    SetupHUD_game()

    SetupPlayerIndicator()

    --Creates filter
    color = COLOR(255, 25, 156, 90)
    filter = FILTER(color)
    F_T["filter"] = filter

    --Creates draw text
    font = font_reg_m
    text = "GAME PAUSED"
    x = (map_x/2-10) * TILESIZE + BORDER
    y = (map_y/2) * TILESIZE + BORDER
    color  = COLOR(255, 255, 255)
    transp = COLOR(0, 0, 0, 0) --Transparent background
    tb = TB(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), text, font, transp, color)
    TB_T["pause"] = tb

end

--Draw gameover effect and text
function draw.gameover_setup()
    local font
    local color, text, x, y, b_color, t_color, filter_color, transp
    local continue_text --text to continue match or go back to setup
    local p, tb, filter, winnertext, cont_tb
    
    SetupHUD_default("simple")

    SetupHUD_game()
    
    continue_text = "Press ENTER to continue"

    --End of match
    if MATCH_BEGIN == false then
        filter_color = COLOR(12, 69, 203, 90)
        text = "------THE ULTIMATE CHAMPION IS PLAYER " .. winner .. "------"
        continue_text = "Press ENTER to go back to setup"

        --Creates a textbox for the champion, right next to the player
        font = font_reg_s
        b_color = COLOR(255, 255, 255, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[winner]
        x = (p.x-2)*TILESIZE + BORDER
        y = (p.y-2)*TILESIZE + BORDER

        tb = TB(x, y, 5*TILESIZE, TILESIZE, ">>CHAMP1ON<<",font, b_color, t_color)
        TB_T["CHAMPION"] = tb

    --Case of a draw
    elseif winner == 0 then
        filter_color = COLOR(255, 0, 0, 90)
        text = "DRAW"
    
    --Case of a single winner
    else
        filter_color = COLOR(12, 69, 203, 90)
        text = "------WINNER IS PLAYER " .. winner .. "------"

        --Creates a textbox for the winner, right next to the player
        font = font_reg_s
        b_color = COLOR(0, 0, 0, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[winner]
        x = (p.x-2)*TILESIZE + BORDER
        y = (p.y-2)*TILESIZE + BORDER

        tb = TB(x, y, 5*TILESIZE, TILESIZE, ">>WINNER<<", font, b_color, t_color)
        TB_T["winner"] = tb

    end
    
    --Creates filter
    filter = FILTER(filter_color)
    F_T["filter"] = filter

     --Creates winner textbox
    font = font_reg_m
    color = COLOR(255, 255, 255)
    transp = COLOR(0, 0, 0, 0) --Transparent background
    tb = TB(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), text, font, transp, color)
    TB_T["winnertxt"] = tb

     --Creates continue textbox
    y = (map_y-5)*TILESIZE + BORDER
    cont_tb = TB(0, y, love.graphics.getWidth(), font:getHeight(continue_text), continue_text, font, transp, color)
    TB_T["continue"] = cont_tb

end

----------------------
--STATE DRAW FUNCTIONS
----------------------

--Draw all stuff from setup
function draw.setup_state()
    local font

    DrawAll()

    --Draw variables
    font = font_but_m
    love.graphics.setColor( 255, 255, 255)
    love.graphics.setFont(font)
    --N_PLAYERS var
    love.graphics.print(N_PLAYERS, 150, 120, 0, 2, 2)

    --GOAL var
    love.graphics.print(GOAL, 500, 120, 0, 2, 2)

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
    local fwidth, fheight, tx, ty, font

    --Draws button box
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b, button.b_color.a)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    
    fwidth  = button.font:getWidth( button.text) --Width of font
    fheight = button.font:getHeight(button.text) --Height of font
    tx = (button.w - fwidth)/2                   --Relative x position of font on textbox
    ty = (button.h - fheight)/2                  --Relative y position of font on textbox

    --Draws button text
    font = font_but_m
    love.graphics.setColor(button.t_color.r, button.t_color.g, button.t_color.b, button.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

--Draw a given textbox
function drawTextBox(textbox)
    local fwidth, fheight, tx, ty, font

    --Draws textbox box
    love.graphics.setColor(textbox.b_color.r, textbox.b_color.g, textbox.b_color.b, textbox.b_color.a)
    love.graphics.rectangle("fill", textbox.x, textbox.y, textbox.w, textbox.h)
    
    fwidth  = textbox.font:getWidth(textbox.text)  --Width of font
    fheight = textbox.font:getHeight(textbox.text) --Height of font
    tx = (textbox.w - fwidth)/2                    --Relative x position of font on textbox
    ty = (textbox.h - fheight)/2                   --Relative y position of font on textbox

    --Draws textbox text
    font = textbox.font
    love.graphics.setColor(textbox.t_color.r, textbox.t_color.g, textbox.t_color.b, textbox.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(textbox.text, textbox.x + tx , textbox.y + ty)

end

--Draw a given text
function drawText(text)
    local font = text.font

    love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
    love.graphics.setFont(font)
    love.graphics.print(text.text, text.x, text.y)

end

--Draw a given filter
function drawFilter(filter)

    love.graphics.setColor(filter.color.r, filter.color.g, filter.color.b, filter.color.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

end

--Draw a given particle
function drawParticle(particle)
    local r = 3 --Particle radiius

    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)
    love.graphics.circle("fill", particle.x, particle.y, r)

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
    local number, x, y, color

    --Draw the tiles with the corresponding color
    for i=1,map_x do
        for j=1,map_y do

            number = map[i][j] --Number of that tile (0 for map or else for player number)
            if number == 0 then
                color = COLOR(map_color.r, map_color.g, map_color.b)
                love.graphics.setColor(color.r, color.g, color.b)
            else
                color = COLOR(P_T[number].b_color.r, P_T[number].b_color.g, P_T[number].b_color.b)
                love.graphics.setColor(color.r, color.g, color.b)
            end

            x = (i-1)*TILESIZE + BORDER
            y = (j-1)*TILESIZE + BORDER
            love.graphics.rectangle("fill", x, y, TILESIZE, TILESIZE) --Draw tile            
        end
    end

end

--Draws players heads
function DrawHeads()
    local dead, x, y, color

    --Draw players heads
    for i, p in ipairs(P_T) do
        
        --Checks if head is dead
        dead = 1
        if p.dead then dead = 0 end

        --Draws heads
        color = COLOR(p.h_color.r * dead, p.h_color.g * dead , p.h_color.b * dead)
        x = (p.x-1)*TILESIZE + BORDER
        y = (p.y-1)*TILESIZE + BORDER
        love.graphics.setColor(color.r, color.g, color.b)
        love.graphics.rectangle("fill", x, y, TILESIZE, TILESIZE) --Draw tile     
    end

end

--------------------
--HUD DRAW FUNCTIONS
--------------------

--Toggles DEBUG
function draw.toggleDebug()
    local font, color, DEBUG_TEXT

    if not DEBUG then 
        font = font_reg_s
        color = COLOR(255, 255, 255)
        DEBUG_TEXT = TXT(150, love.graphics.getHeight() - 2* TILESIZE, "DEBUG ON", font, color)
        TXT_T["DEBUG"] = DEBUG_TEXT
        DEBUG = true
    else
        TXT_T["DEBUG"] = nil
        DEBUG = false
    end

end

--Draw the default HUD
function SetupHUD_default(mode)  
    local text, txt, x, y, DEBUG_TEXT
    local font = font_reg_s
    local color = COLOR(255, 255, 255)
    
    
    --set text according to mode
    if mode == "simple" then
        text = "(q)uit"
    elseif mode == "complete" then
        text = "(q)uit        (p)ause"
    end

    --commands text
    x = 0
    y = love.graphics.getHeight() - 2* TILESIZE
    txt = TXT(x, y, text, font, color)
    TXT_T["commands"] = txt

    --DEBUG text
    if DEBUG then
        font = font_reg_s
        color = COLOR(255, 255, 255)
        x = 150
        y = love.graphics.getHeight() - 2* TILESIZE
        DEBUG_TEXT = TXT(x, y, "DEBUG ON", font, color)
        TXT_T["DEBUG"] = DEBUG_TEXT
    end

end

--Draw the game HUD
function SetupHUD_game()
    local text, x, y, label, txt
    local font = font_reg_s
    local color = COLOR(255, 255, 255)

    --Score Text
    x = 80
    y = 20
    txt = TXT(x, y, "SCORE:", font, color)
    TXT_T["SCOREtxt"] = txt

    --Best Of Text
    x = 100 + #P_T*45 + 80
    y = 20
    txt = TXT(x, y, "GOAL:", font, color)
    TXT_T["goal_txt"] = txt

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
    local label, txt, x, y
    local font = font_reg_s
    local color = COLOR(255, 255, 255)
    
    for i, p in ipairs(P_T) do
        --Creates player indicator text
        label = "player"..p.number.."txt"
        x = (p.x-1)*TILESIZE + BORDER
        y = (p.y-5)*TILESIZE + BORDER
        txt = TXT(x, y, "P" .. p.number, font, color)
        TXT_T[label] = txt

        --Creates players control/CPU text
        if  p.control == "WASD" then
            label = "WASD"
            x = (p.x-2)*TILESIZE + 1 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "WASD", font, color)
        elseif p.control == "ARROWS" then
            label = "ARROWS"
            x = (p.x-2)*TILESIZE - 7 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "ARROWS", font, color)
        else
            label = "CPU"..i
            x = (p.x-1)*TILESIZE - 4 + BORDER
            y = (p.y-3)*TILESIZE + BORDER
            txt = TXT(x, y, "CPU", font, color)
        end
        TXT_T[label] = txt
    end

end

----------------------
--OTHER DRAW FUNCTIONS
----------------------

--Draw countdown in the beggining of every match
function DrawCountdown()
    local color, font, x, y

    color = COLOR(184, 184, 234)
    font = font_reg_m
    x = map_x/2 * TILESIZE + BORDER
    y = (map_y/2 - 5) * TILESIZE + BORDER

    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.setFont(font)
    love.graphics.print(countdown, x, y, 0, 2, 2)

end

--Draw all players score
function DrawScore()
    local color, font, x, y, scale_x, scale_y

    color = COLOR(255,255,255)
    font = font_reg_s
    scale_x = 1.2
    scale_y = 1.2

    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.setFont(font)
    
    --Draw players score
    for i, p in ipairs(P_T) do
        x = 100 + 45*p.number
        y = 20
        love.graphics.print(p.score, x, y, 0, scale_x, scale_y)
    end

    --Draw Best of
    x = 100 + #P_T*45 + 140
    y = 19
    love.graphics.print(GOAL, x, y, 0, scale_x, scale_y)

end

--Return functions
return draw
