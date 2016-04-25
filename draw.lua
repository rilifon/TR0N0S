local Util     = require "util"
local Particle = require "particle"
local RGB      = require "rgb"
local FX       = require "fx"



--MODULE FOR DRAWING STUFF--

local draw = {}

local FONT_FIX_X = 10
local FONT_FIX_Y = 8

-----------------------
--STATE SETUP FUNCTIONS
-----------------------

function draw.setup_setup()
    local x, y, w, h, font, txt, text, transp, color, img, sx, sy
    local rgb_b, rgb_h, P, p, color_id 
    local gap --Gap between two buttons
    local color_b, color_t, exp_color
    local duration, max_part, speed, decaying

    --Create buttons for all already existing players
    Util.updatePlayersB()

    --Chooses a simple HUD
    SetupHUD_default("simple")

    -----------------------------
    --Creates setup buttons
    -----------------------------

    gap = 40
    color_t   = COLOR(0, 0, 0)
    duration = .5                   --Duration of particles
    max_part = 45                   --Max number of particles
    speed    = 200                  --Speed of particles
    decaying = .99                  --Decaying speed of particles

    --N_PLAYERS BUTTON
    font = font_but_l

    --Up button
    y = PB_T["P"..N_PLAYERS.."pb"].y + PB_T["P"..N_PLAYERS.."pb"].h + 25
    color_b  = COLOR(23, 233, 0)
    img = bt_img_plus
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    x = love.graphics.getWidth()/2 --Get half the screen
    n_player_up = But_Img(img, x, y, w, h, sx, sy, "+", font, color_t,
        function()
            local this = n_player_up
            local x = this.x
            local y = this.y
            local w = this.w
            local h = this.h
            local pbh = PB_T["P"..N_PLAYERS.."pb"].h + 5 --Height of players button
            local x_nil = 0
            local exp_color = COLOR(65,168,17)   --Color of particle explosion
            local bot

            if N_PLAYERS < MAX_PLAYERS then
               
                --Increases players
                N_PLAYERS = N_PLAYERS + 1

                --Particles
                FX.particle_explosion(x+w/2, y+h/2 + pbh, exp_color, duration, max_part, speed, decaying)

                --Shrink effect
                FX.pulse(n_player_up, 0.95, 0.95)
                
                --Insert new CPU player
                color_id = RGB.randomBaseColor()
                rgb_b = RGB.randomColor(color_id)
                rgb_h = RGB.randomDarkColor(rgb_b)
                p = PLAYER(N_PLAYERS, false, nil, nil, nil, nil, rgb_b, rgb_h, true, 1, nil)
                p.color_id = color_id
                table.insert(P_T, p)

                --Adjust positions of buttons
                FX.smoothMove(n_player_up, n_player_up.x, n_player_up.y + pbh, .5, 'out-back')
                FX.smoothMove(n_player_down, n_player_down.x, n_player_down.y + pbh, .5, 'out-back')
                
                bot = I_T["bot_pb_i"]

                FX.smoothMove(bot, bot.x, bot.y + pbh, .4, 'out-back')

                --Creates a player button on setup screen
                Util.createPlayerButton(p)

            end
        end
    )
    BI_T["n_player_up"] = n_player_up

    --Down button
    color_b  = COLOR(233, 10, 0)
    img = bt_img_minus
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    x = x - w --Get correct position
    n_player_down = But_Img(img, x, y, w, h, sx, sy, "-", font, color_t,
        function()
            local this = n_player_down
            local x = this.x
            local y = this.y
            local w = this.w
            local h = this.h
            local pbh = PB_T["P"..N_PLAYERS.."pb"].h + 5 --Height of players button
            local exp_color = COLOR(217,9,18)   --Color of particle explosion)
            local bot 

            if N_PLAYERS > 1 then
                
                --Particles
                FX.particle_explosion(x+w/2, y+h/2 - 3*pbh/5, exp_color, duration, max_part, speed, decaying)

                --Shrink effect
                FX.pulse(n_player_down, 0.95, 0.95)

                p = P_T[N_PLAYERS]
                if p.control == "WASD" then WASD_PLAYER = 0
                elseif p.control == "ARROWS" then ARROWS_PLAYER = 0 end
                
                --"Free" player color
                C_MT[p.color_id] = 0

                --Removes last player
                table.remove(P_T, N_PLAYERS)
                
                --Adjust positions of buttons
                FX.smoothMove(n_player_up, n_player_up.x, n_player_up.y - pbh, .3, 'in-out-sine')
                FX.smoothMove(n_player_down, n_player_down.x, n_player_down.y - pbh, .3, 'in-out-sine')
                
                bot = I_T["bot_pb_i"]

                FX.smoothMove(bot, bot.x, bot.y - pbh, .3, 'in-out-sine')

                --Decreases players
                N_PLAYERS = N_PLAYERS - 1

                Util.removePlayerButton(p)

            end
        end
    )
    BI_T["n_player_down"] = n_player_down

    --GOAL BUTTON
    x = 450
    y = 5
    font = font_but_l
    color_b   = COLOR(233, 131, 0)  --Color of button background
    img = bt_img_plus
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    --Up button
    goal_up = But_Img(img, x, y, w, h, sx, sy, "+", font, color_t,
        function()
            local this = goal_up
            local x = this.x
            local y = this.y
            local w = this.w
            local h = this.h
            local exp_color = COLOR(65,168,17)   --Color of particle explosion

            --Particles
            FX.particle_explosion(x+w/2, y+h/2, exp_color, duration, max_part, speed, decaying) 

            --Shrink effect
            FX.pulse(goal_up, 0.85, 0.85)

            GOAL = GOAL + 1
        end
    )
    BI_T["goal_up"] =  goal_up

    --Down button
    img = bt_img_minus
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    y = y + h - 20
    goal_down = But_Img(img, x, y, w, h, sx, sy, "-", font, color_t,
        function()
            local this = goal_down
            local x = this.x
            local y = this.y
            local w = this.w
            local h = this.h
            local exp_color = COLOR(217,9,18)   --Color of particle explosion

            if GOAL > 1 then
                
                --Particles
                FX.particle_explosion(x+w/2, y+h/2, exp_color, duration, max_part, speed, decaying)

                --Shrink effect
                FX.pulse(goal_down, 0.85, 0.85)

                GOAL = GOAL - 1
            end
        end
    )
    BI_T["goal_down"] = goal_down



    --------------------------------
    --Creates setup images with text
    --------------------------------
    
    color_b = COLOR(233, 131, 0)
    color_t = COLOR(0, 0, 0)
    font = font_but_m

    --N_PLAYERS IMAGE
    img = bt_img
    x  = 15
    y  = 10
    sx = 1
    sy = .4
    w = img:getWidth()
    h = img:getHeight()
    n_player_i = IMG(img, x, y, w, h, sx, sy, "NUMBER OF PLAYERS", font, color_t)
    I_T["n_player_i"] = n_player_i

    --GOAL TEXTBOX
    img = bt_img
    x = 540
    y = 10
    sx = .4
    sy = .4
    w = img:getWidth()
    h = img:getHeight()
    goal_i = IMG(img, x, y, w, h, sx, sy, "GOAL", font, color_t)
    I_T["goal_i"] = goal_i

    ----------------------
    --Creates setup images
    ----------------------

    --TOP OF PLAYERS BUTTON
    img = border_top_img
    x  = 65
    y  = 150
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    top_pb_i = IMG(img, x, y, w, h, sx, sy, "", font, color_t)
    I_T["top_pb_i"] = top_pb_i


    --BOTTOM OF PLAYERS BUTTON
    img = border_bot_img
    x  = 65
    y  = PB_T["P"..N_PLAYERS.."pb"].y - 40
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    bot_pb_i = IMG(img, x, y, w, h, sx, sy, "", font, color_t)
    I_T["bot_pb_i"] = bot_pb_i

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

    BackgroundTransition()

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
    love.graphics.print(N_PLAYERS, 240, 130, 0, 2, 2)

    --GOAL var
    love.graphics.print(GOAL, 620, 130, 0, 2, 2)

end


--Draw all stuff from game
function draw.game_state()
    
    DrawScore()
    
    DrawAll("inGame")

    if not game_begin then
        DrawCountdown()
    end

end

--Draw all stuff from pause
function draw.pause_state()

    DrawScore()
    
    DrawAll("inGame")

end

--Draw all stuff from gameover
function draw.gameover_state()

    DrawScore()
    
    DrawAll("inGame")

end


----------------------
--BASIC DRAW FUNCTIONS
----------------------

--Draws every drawable from tables
function DrawAll(mode)

    if mode == "inGame" then
        DrawMAP()     --Draws the background

        DrawPlayers() --Draws all players on screen
    end

    DrawB()       --Draws all default buttons

    DrawBI()      --Draws all default buttons with images

    DrawBOX()     --Draws all default boxes

    DrawPB()      --Draws all default player buttons

    DrawI()       --Draws all default images with text

    DrawPART()    --Draws all default particles

    DrawF()       --Draws all default filters

    DrawTXT()     --Draws all default texts

    DrawTB()      --Draws all default textboxes

end

--Draws all default textboxes
function DrawTB()
    
    for i, v in pairs(TB_T) do
        drawTextBox(v)
    end

end

--Draws all default buttons
function DrawB()

    for i, v in pairs(B_T) do
        drawButton(v)
    end

end

--Draws all default buttons with images
function DrawBI()

    for i, v in pairs(BI_T) do
        drawButtonImg(v)
    end

end

--Draws all default images with text
function DrawI()

    for i, v in pairs(I_T) do
        drawImg(v)
    end

end


--Draws all default texts
function DrawTXT()

    for i, v in pairs(TXT_T) do
        drawText(v)
    end

end

--Draws all filters
function DrawF()

    for i, v in pairs(F_T) do
        drawFilter(v)
    end

end

--Draws all players buttons
function DrawPB()
   
    --Draws the glow effect
    love.graphics.setShader(Glow_Shader)
    SHADER = "Glow"
    for i, v in pairs(PB_T) do
        drawGlowButton(v)
    end
    love.graphics.setShader()
    SHADER = nil

    for i, v in pairs(PB_T) do
        drawButton(v)
    end

end

--Draws all particles
function DrawPART()
   
    for i, v in pairs(PART_T) do
        drawParticle(v)
    end

end

--Draws all boxes with a glow effect below
function DrawBOX()
   
    for i, v in pairs(BOX_T) do
        drawBox(v)
    end

end

--Updates all background tiles
function DrawMAP()
    
    drawBackground()

end

 --Draw players glow effect, body and heads
 --IS THE CAUSE OF LAG
function DrawPlayers()

    --Draws the glow effect
    love.graphics.setShader(Glow_Shader)
    SHADER = "Glow"
    for i, tile in pairs(MAP_T) do
        drawGlowTile(tile)
    end
    love.graphics.setShader()
    SHADER = nil

    --Draws the players
    for i, tile in pairs(MAP_T) do
        drawTile(tile)
    end

end

-----------

--Draws a given button
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
    font = button.font
    love.graphics.setColor(button.t_color.r, button.t_color.g, button.t_color.b, button.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(button.text, button.x + tx , button.y + ty)

end

--Draws a glow for a given button
function drawGlowButton(button)
    local eps = EPS_2

    --Draws button glow
    love.graphics.setColor(button.b_color.r, button.b_color.g, button.b_color.b, button.b_color.a)
    love.graphics.draw(PIXEL, button.x-eps, button.y-eps, 0, button.w+2*eps, button.h+2*eps)
    

end

--Draws a given button with image
function drawButtonImg(but)
    local fwidth, fheight, tx, ty, font, fix

    fix = 5 --Fix font position on images

    --Draws image
    love.graphics.setColor(255,255,255)
    love.graphics.draw(but.img, but.x, but.y, 0, but.sx, but.sy)
    
    font = but.font
    fwidth  = font:getWidth( but.text) --Width of font
    fheight = font:getHeight(but.text) --Height of font
    tx = (but.w*but.sx - fwidth)/2     --Relative x position of font on textbox
    ty = (but.h*but.sy - fheight)/2 - fix     --Relative y position of font on textbox

    --Draws button text
    love.graphics.setColor(but.t_color.r, but.t_color.g, but.t_color.b, but.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(but.text, but.x + tx , but.y + ty)

    if DEBUG then
        love.graphics.setColor(255,0,0)
        love.graphics.rectangle("fill", but.x, but.y, but.w, but.h)
    end

end

--Draws a given image with text
function drawImg(img)
    local fwidth, fheight, tx, ty, font

    --Draws image
    love.graphics.setColor(255,255,255)
    love.graphics.draw(img.img, img.x, img.y, 0, img.sx, img.sy)
    
    font = img.font
    fwidth  = font:getWidth( img.text) --Width of font
    fheight = font:getHeight(img.text) --Height of font
    tx = (img.w*img.sx - fwidth)/2     --Relative x position of font on textbox
    ty = (img.h*img.sy - fheight)/2    --Relative y position of font on textbox

    --Draws image text
    love.graphics.setColor(img.t_color.r, img.t_color.g, img.t_color.b, img.t_color.a)
    love.graphics.setFont(font)
    love.graphics.print(img.text, img.x + tx , img.y + ty)

end


--Draws a given textbox
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

--Draws a given text
function drawText(text)
    local font = text.font

    love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
    love.graphics.setFont(font)
    love.graphics.print(text.text, text.x, text.y)

end

--Draws a given filter
function drawFilter(filter)

    love.graphics.setColor(filter.color.r, filter.color.g, filter.color.b, filter.color.a)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

end

--Draws a given particle
function drawParticle(particle)
    local r = 3 --Particle radius

    love.graphics.setColor(particle.color.r, particle.color.g, particle.color.b, particle.color.a)
    love.graphics.circle("fill", particle.x, particle.y, r)

end

--Draws a given box
function drawBox(box)

    --Draws box
    love.graphics.setColor(box.color.r, box.color.g, box.color.b, box.color.a)
    love.graphics.draw(PIXEL, box.x, box.y, 0, box.w, box.h)

end

--Draws a given box with glow
function drawGlowBox(box)
    local eps = EPS_2

    --Draws box
    love.graphics.setColor(box.color.r, box.color.g, box.color.b, box.color.a)
    love.graphics.draw(PIXEL, box.x-eps, box.y-eps, 0, box.w+2*eps, box.h+2*eps)

end

--Draws the background
function drawBackground(tile)
    local x, y, w, h
    
    w = map_x*TILESIZE
    h = map_y*TILESIZE
    x = BORDER
    y = BORDER

    love.graphics.setColor(map_color.r, map_color.g, map_color.b, map_color.a)
    love.graphics.draw(PIXEL, x, y, 0, w, h)

end

--Draws a tile 
function drawTile(tile)
    local x, y, w, h
    
    w = TILESIZE
    h = TILESIZE
    x = BORDER + (tile.x - 1)*TILESIZE
    y = BORDER + (tile.y - 1)*TILESIZE

    --Draws tile
    love.graphics.setColor(tile.color.r, tile.color.g, tile.color.b, tile.color.a)
    love.graphics.draw(PIXEL, x, y, 0, w, h)

end

--Draws a glow effect for every tile
function drawGlowTile(tile)
    local x, y, w, h
    
    e = EPS   --Epsilon, range the glow effect will achieve
    w = TILESIZE
    h = TILESIZE
    x = BORDER + (tile.x - 1)*TILESIZE - e
    y = BORDER + (tile.y - 1)*TILESIZE - e

    --Draws tile
    love.graphics.setColor(tile.color.r, tile.color.g, tile.color.b, tile.color.a)
    love.graphics.draw(PIXEL, x, y, 0, w+2*e, h+2*e)

end

--------------------
--MAP DRAW FUNCTIONS
--------------------

--Choses a random color from a table and transitions the map background to it 
function BackgroundTransition()
    local r, g, b, ratio
    local duration = 5
    local diff = 0
    local ori_color = map_color

    --Fixing imprecisions
    ori_color.r = math.floor(ori_color.r + .5)
    ori_color.g = math.floor(ori_color.g + .5)
    ori_color.b = math.floor(ori_color.b + .5)

    --Get a random different color for map background
    targetColor = MC_T[math.random(#MC_T)]

    while ((targetColor.r == ori_color.r) and
           (targetColor.g == ori_color.g) and
           (targetColor.b == ori_color.b)) do

        targetColor = MC_T[math.random(#MC_T)]
    end

    FX.smoothColor(map_color, ori_color, targetColor, duration, 'linear')

    --Starts a timer that gradually increse
    Color_Timer.after(duration,
        
        --Calls parent function so that the transition is continuous
        function()

            BackgroundTransition()

        end
    )

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

    color = COLOR(255, 255, 255)
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
