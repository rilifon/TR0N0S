local Util      = require "util"
local Particle  = require "particle"
local RGB       = require "rgb"
local FX        = require "fx"
local UD        = require "utildraw"
local Primitive = require "primitive"

--MODULE FOR HIGH-LEVEL DRAWING STUFF--

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
    UD.updatePlayersB()

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
    img = IMG_BUT_PLUS
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
                UD.createPlayerButton(p)

            end
        end
    )
    BI_T["n_player_up"] = n_player_up

    --Down button
    color_b  = COLOR(233, 10, 0)
    img = IMG_BUT_MINUS
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

                UD.removePlayerButton(p)

            end
        end
    )
    BI_T["n_player_down"] = n_player_down

    --GOAL BUTTON
    x = 480
    y = 25
    font = font_but_l
    color_b   = COLOR(233, 131, 0)  --Color of button background
    img = IMG_BUT_PLUS
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
    img = IMG_BUT_MINUS
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
    img = IMG_DEFAULT
    x  = 45
    y  = 30
    sx = 1
    sy = .4
    w = img:getWidth()
    h = img:getHeight()
    n_player_i = IMG(img, x, y, w, h, sx, sy, "NUMBER OF PLAYERS", font, color_t)
    I_T["n_player_i"] = n_player_i

    --GOAL TEXTBOX
    img = IMG_DEFAULT
    x = 570
    y = 30
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
    img = IMG_BORDER_TOP
    x  = BORDER - 25
    y  = 210
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    top_pb_i = IMG(img, x, y, w, h, sx, sy, "", font, color_t)
    I_T["top_pb_i"] = top_pb_i


    --BOTTOM OF PLAYERS BUTTON
    img = IMG_BORDER_BOT
    x  = BORDER - 25
    y  = PB_T["P"..N_PLAYERS.."pb"].y - 43
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

    if not GAME_BEGIN then
        UD.setupPlayerIndicator()
        if not BORDER_LOOP then
            FX.pulseLoop(I_T["map_border_i"], 1.01, 1.01, 3, true)
            BORDER_LOOP = true
        end
    end
    
end

--Draw pause effect and text
function draw.pause_setup()
    local color, filter, x, y, font, text, transp, tb
    
    SetupHUD_default("complete")

    SetupHUD_game()

    UD.setupPlayerIndicator()

    --Creates filter
    color = COLOR(255, 255, 255, 0)
    filter = FILTER(color)
    F_T["filter"] = filter
    --Creates fade in effect
    FX.smoothColor(F_T["filter"].color, COLOR(255, 25, 156, 90), 2, 'linear')

    --Creates draw text
    font = font_reg_m
    text = "GAME PAUSED"
    x = (MAP_X/2-10) * TILESIZE + BORDER
    y = (MAP_Y/2) * TILESIZE + BORDER
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
    filter = FILTER(COLOR(255,255,255,0))
    F_T["filter"] = filter
    --Filter fade-in effect
    FX.smoothColor(F_T["filter"].color, filter_color, 1, 'linear')

     --Creates winner textbox
    font = font_reg_m
    color = COLOR(255, 255, 255)
    transp = COLOR(0, 0, 0, 0) --Transparent background
    tb = TB(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), text, font, transp, color)
    TB_T["winnertxt"] = tb

     --Creates continue textbox
    y = (MAP_Y-5)*TILESIZE + BORDER
    cont_tb = TB(0, y, love.graphics.getWidth(), font:getHeight(continue_text), continue_text, font, transp, color)
    TB_T["continue"] = cont_tb

end

----------------------
--STATE DRAW FUNCTIONS
----------------------

--Draw all stuff from setup
function draw.setup_state()
    local font

    Primitive.drawAll()

    --Draw variables
    font = font_but_m
    love.graphics.setColor( 255, 255, 255)
    love.graphics.setFont(font)
    --N_PLAYERS var
    love.graphics.print(N_PLAYERS, 270, 160, 0, 2, 2)

    --GOAL var
    love.graphics.print(GOAL, 640, 155, 0, 2, 2)

end


--Draw all stuff from game
function draw.game_state()
        
    Primitive.drawAll("inGame")

    if not GAME_BEGIN then
        DrawCountdown()
    end

end

--Draw all stuff from pause
function draw.pause_state()
    
    Primitive.drawAll("inGame")

end

--Draw all stuff from gameover
function draw.gameover_state()
    
    Primitive.drawAll("inGame")

end

--------------------
--HUD DRAW FUNCTIONS
--------------------

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
        UD.createDebugText()
    end

    --DEBUG text
    if DEBUG_DRAW then
        UD.createDebugDrawText()
    end

end

--Draw the game HUD
function SetupHUD_game()
    local text, x, y, label, txt, sx, sy
    local font = font_reg_s
    local color = COLOR(255, 255, 255)
    local img, score, w, h

    --SCORE STUFF --
    
    --Each player score
    img = IMG_SCORE
    color = COLOR(0,0,0,255)
    font = font_reg_m
    y = 0
    sx = .5
    sy = .5
    for i, p in ipairs(P_T) do
        w = img:getWidth()
        h = img:getHeight()
        x =  (w-10)*sx * p.number-90
        text = p.score
        label = p.number.."score"
        score = IMG(img, x, y, w, h, sx, sy, text, font, color)
        I_T[label] = score
    end
    
    --Player indicator
    sx = 1
    sy = 1
    y = 35
    font = font_reg_m
    for i, p in ipairs(P_T) do
        color = COLOR(p.b_color.r, p.b_color.g, p.b_color.b)
        x =  p.number*(w-10)*.5 -100
        text = "P"..p.number
        label = p.number.."scoreindicator"
        txt = TXT(x, y, text, font, color, sx, sy)
        TXT_T[label] = txt
    end

    --GOAL STUFF--

    --Goal Text
    x = love.graphics.getWidth()/2 - 80
    y = BORDER + MAP_Y*TILESIZE + 50
    color = COLOR(51,100,245)
    font = font_reg_m
    sx = 1
    sy = 1
    txt = TXT(x, y, "GOAL:", font, color, sx, sy)
    TXT_T["goal_txt"] = txt

    sx = .6
    sy = .6

    --Draw Goal value
    y = y - 40
    x = x + 50
    img = IMG_SCORE
    color = COLOR(0,0,0)
    text = GOAL
    score = IMG(img, x, y, w, h, sx, sy, text, font, color)
    I_T["goal_value"] = score

    --MAP BORDER--

    if not GAME_BEGIN and not BORDER_LOOP then
        img = IMG_BORDER_MAP
        x  = BORDER - 95
        y  = BORDER - 95
        sx = 1
        sy = 1
        w = img:getWidth()
        h = img:getHeight()
        map_border = IMG(img, x, y, w, h, sx, sy, "", font, color)
        I_T["map_border_i"] = map_border
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
    x = MAP_X/2 * TILESIZE + BORDER
    y = (MAP_Y/2 - 5) * TILESIZE + BORDER

    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.setFont(font)
    love.graphics.print(countdown, x, y, 0, 2, 2)

end

--Return functions
return draw
