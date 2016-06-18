local Util      = require "util"
local Particle  = require "particle"
local RGB       = require "rgb"
local FX        = require "fx"
local UD        = require "utildraw"
local Primitive = require "primitive"

--MODULE FOR HIGH-LEVEL DRAWING STUFF--

local draw = {}

--Button functions
local n_player_up_func   = require "buttons.n_player_up"
local n_player_down_func = require "buttons.n_player_down"
local goal_up_func       = require "buttons.goal_up"
local goal_down_func     = require "buttons.goal_down"

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
    SetupHUD_default("setup")

    --BUTTONS FLAGS
    N_PLAYER_UP_FLAG = false
    N_PLAYER_DOWN_FLAG = false
    GOAL_UP_FLAG = false
    GOAL_DOWN_FLAG = false

    -----------------------------
    --Creates setup buttons
    -----------------------------

    gap = 40
    color_t   = COLOR(0, 0, 0)      --Color of text

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
    n_player_up = But_Img(img, x, y, w, h, sx, sy, "+", font, color_t, n_player_up_func)
    BI_T["n_player_up"] = n_player_up
    B_GLOW_T["n_player_up"] = BOX(x + w*(.5 - 1/(2*IWR)) , y + h*(.5 - 1/(2*IHR)), w/IWR, h/IHR, GREEN_COLOR)

    --Down button
    color_b  = COLOR(233, 10, 0)
    img = IMG_BUT_MINUS
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    x = x - w --Get correct position
    n_player_down = But_Img(img, x, y, w, h, sx, sy, "-", font, color_t, n_player_down_func)
    BI_T["n_player_down"] = n_player_down
    B_GLOW_T["n_player_down"] = BOX(x + w*(.5 - 1/(2*IWR)) , y + h*(.5 - 1/(2*IHR)), w/IWR, h/IHR, RED_COLOR)

    --GOAL BUTTON
    x = 580
    y = 45
    font = font_but_l
    color_b   = COLOR(233, 131, 0)  --Color of button background
    img = IMG_BUT_PLUS
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    --Up button
    goal_up = But_Img(img, x, y, w, h, sx, sy, "+", font, color_t, goal_up_func)
    BI_T["goal_up"] =  goal_up
    B_GLOW_T["goal_up"] = BOX(x + w*(.5 - 1/(2*IWR)) , y + h*(.5 - 1/(2*IHR)), w/IWR, h/IHR, GREEN_COLOR)

    --Down button
    img = IMG_BUT_MINUS_INV
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    y = y + h - 20
    goal_down = But_Img(img, x, y, w, h, sx, sy, "-", font, color_t, goal_down_func)
    BI_T["goal_down"] = goal_down
    B_GLOW_T["goal_down"] = BOX(x + w*(.5 - 1/(2*IWR)) , y + h*(.5 - 1/(2*IHR)), w/IWR, h/IHR, RED_COLOR)

    --------------------------------
    --Creates setup images with text
    --------------------------------
    
    color_b = COLOR(233, 131, 0)
    color_t = COLOR(0, 0, 0)

    --N_PLAYERS IMAGE
    img = IMG_SETUP_NP
    font = font_but_ml
    x  = -60
    y  = 30
    sx = 3.8
    sy = .9
    w = img:getWidth()
    h = img:getHeight()
    n_player_i = IMG(img, x, y, w, h, sx, sy, "NUMBER OF PLAYERS", font, color_t)
    I_T["n_player_i"] = n_player_i

    --N_PLAYERS VALUE
    sx = .6
    font = font_reg_m
    sy = .6
    y = y + 120
    x = 2.08*love.graphics.getWidth()/8
    img = IMG_VAR
    w = img:getWidth()
    h = img:getHeight()
    color = COLOR(0,0,0)
    text = N_PLAYERS
    score = IMG(img, x, y, w, h, sx, sy, text, font, color)
    I_T["n_players_value"] = score

    --GOAL TEXTBOX
    img = IMG_SETUP_GOAL
    font = font_but_ml
    x = 660
    y = 40
    sx = 1
    sy = .8
    w = img:getWidth()
    h = img:getHeight()
    goal_i = IMG(img, x, y, w, h, sx, sy, "GOAL", font, color_t)
    I_T["goal_i"] = goal_i

    --GOAL VALUE
    sx = .6
    font = font_reg_m
    sy = .6
    y = y + 110
    x = 4*love.graphics.getWidth()/6 + 100
    img = IMG_VAR
    w = img:getWidth()
    h = img:getHeight()
    color = COLOR(0,0,0)
    text = GOAL
    score = IMG(img, x, y, w, h, sx, sy, text, font, color)
    I_T["goal_value"] = score

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

    -----------------------------
    --Creates effects on images
    -----------------------------

    FX.pulseLoop(I_T["goal_value"], .65, .65, 1.5, true)
    FX.pulseLoop(I_T["goal_i"], 1.03, .83, 1.5, true)
    FX.pulseLoop(I_T["n_players_value"], .65, .65, 1.5, true)
    FX.pulseLoop(I_T["n_player_i"], 3.85, .95, 1.5, true)

end

--Draw game countdown and text
function draw.game_setup()
    local color, font, transp, tb, text


    SetupHUD_default("game")

    SetupHUD_game()

    if not GAME_BEGIN then
        
        --Creates countdown text
        font = font_but_l
        text = COUNTDOWN
        color  = COLOR(255, 255, 255, 0)
        transp = COLOR(0, 0, 0, 0) --Transparent background
        tb = TB(0, 0, love.graphics.getWidth(), love.graphics.getHeight(), text, font, transp, color)
        TB_T["countdown"] = tb
        --Creates fade-in for countdown
        H_T["Fade-in countdown"] = Game_Timer.after((N_PLAYERS-1)*.6, 
            function()
                FX.smoothAlpha(TB_T["countdown"].t_color, 255, .8, "linear")
            end
        )

        UD.setupPlayerIndicator()
        if not EFFECT_LOOP then
            FX.pulseLoop(I_T["map_border_i"], 1.01, 1.01, 3, true)
            FX.pulseLoop(I_T["goal_value"], .63, .63, 1.5, true)
            EFFECT_LOOP = true
        end
    end
    
end

--Draw pause effect and text
function draw.pause_setup()
    local color, filter, x, y, font, text, transp, tb
    
    SetupHUD_default("game")

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
    local p, tb, filter, winnertext, cont_tb, winner_name

    SetupHUD_default("gameover")

    SetupHUD_game()
    
    continue_text = "Press ENTER to continue"
    
    if WINNER ~= 0 then
        winner_name = P_T[WINNER].name
        winner_name = string.upper(winner_name)
    end

    --End of match
    if MATCH_BEGIN == false then
        filter_color = COLOR(12, 69, 203, 90)
        if P_T[WINNER].name == "" then
            text = "------THE ULTIMATE CHAMPION IS PLAYER " .. WINNER .. "------"
        else
            text = "------THE ULTIMATE CHAMPION IS " .. winner_name .. "------"
        end
        continue_text = "Press ENTER to go back to setup"

        --Creates a textbox for the champion, right next to the player
        font = font_reg_s
        b_color = COLOR(255, 255, 255, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[WINNER]
        x = (p.x-2)*TILESIZE + BORDER
        y = (p.y-2)*TILESIZE + BORDER

        tb = TB(x, y, 5*TILESIZE, TILESIZE, ">>CHAMP1ON<<",font, b_color, t_color)
        TB_T["CHAMPION"] = tb

    --Case of a draw
    elseif WINNER == 0 then
        filter_color = COLOR(255, 0, 0, 90)
        text = "DRAW"
    
    --Case of a single winner
    else
        filter_color = COLOR(12, 69, 203, 90)
        if P_T[WINNER].name == "" then
            text = "------WINNER IS PLAYER " .. WINNER .. "------"
        else
            text = "------WINNER IS " .. winner_name .. "------"
        end

        --Creates a textbox for the winner, right next to the player
        font = font_reg_s
        b_color = COLOR(0, 0, 0, 20) --Box color
        t_color = COLOR(255, 255, 255)     --Text color 
        p = P_T[WINNER]
        x = (p.x-2)*TILESIZE + BORDER
        y = (p.y-2)*TILESIZE + BORDER

        tb = TB(x, y, 5*TILESIZE, TILESIZE, ">>WINNER<<", font, b_color, t_color)
        TB_T["winner"] = tb

    end
    
    --Creates filter
    filter = FILTER(COLOR(255,255,255,0))
    F_T["filter"] = filter
    --Filter fade-in effect
    FX.smoothColor(F_T["filter"].color, filter_color, .7, 'linear')

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

    Primitive.drawAll()

end


--Draw all stuff from game
function draw.game_state()
        
    Primitive.drawAll("inGame")

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
    local o, img, w, h, sx, sy
    local font
    local color, g_c
    
    g_c = PURPLE_COLOR
    
    -------------
    --HUD BUTTONS
    -------------

    --"quit" button
    img = IMG_COM
    color = COLOR(54,9,14)
    font = font_reg_m
    w = img:getWidth()
    h = img:getHeight()
    sx = .4
    sy = 1.1
    x = 0
    y = love.graphics.getHeight() - 90 
    o = But_Img(img, x, y, w, h, sx, sy, "X", font, color,
        function()
            Util.quit()
        end
    )
    HUD_T["quit_hud"] = o
    B_GLOW_T["quit_hud"] = BOX(x + w*sx*(.5 - 1/(2*IWR)) , y + h*sy*(.5 - 1/(2*IHR)), w*sx/IWR, h*sy/IHR, g_c)


    if mode == "setup" then
        --Nothing for now
    else
        img = IMG_COM
        w = img:getWidth()
        h = img:getHeight()
        y = love.graphics.getHeight() - 90 
        sx = .7
        sy = 1.1
        
        --"go back" button
        color = COLOR(0,0,0)
        font = font_reg_ms
        x = love.graphics.getWidth() - 2*w*sx + 40
        o = But_Img(img, x, y, w, h, sx, sy, "(b)ack", font, color,
            function()
                Util.goBack()
            end
        )
        HUD_T["back_hud"] = o
        B_GLOW_T["back_hud"] = BOX(x + w*sx*(.5 - 1/(2*IWR)) , y + h*sy*(.5 - 1/(2*IHR)), w*sx/IWR, h*sy/IHR, g_c)
         
        --"pause" button
        x = love.graphics.getWidth() - w*sx
        o = But_Img(img, x, y, w, h, sx, sy, "(p)ause", font, color,
            function()
                Util.pause()
            end
        )
        HUD_T["pause_hud"] = o
        B_GLOW_T["pause_hud"] = BOX(x + w*sx*(.5 - 1/(2*IWR)) , y + h*sy*(.5 - 1/(2*IHR)), w*sx/IWR, h*sy/IHR, g_c)

    end

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
        --Position is based on number of players playing to centralize score
        x =  (w-10)*sx * p.number-90 + ((MAX_PLAYERS-N_PLAYERS)/2)*(w-10)*sx
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
        --Position is based on number of players playing to centralize score
        x =  p.number*(w-10)*.5 - 100 + ((MAX_PLAYERS-N_PLAYERS)/2)*(w-10)*.5
        text = "P"..p.number
        label = p.number.."scoreindicator"
        txt = TXT(x, y, text, font, color, sx, sy)
        TXT_T[label] = txt
    end

    --GOAL STUFF--

    --Goal Text
    x = love.graphics.getWidth()/2 - 80
    y = BORDER + MAP_Y*TILESIZE + 60
    color = COLOR(51,100,245)
    font = font_reg_m
    sx = 1
    sy = 1
    txt = TXT(x, y, "GOAL:", font, color, sx, sy)
    TXT_T["goal_txt"] = txt


    --Draw Goal Value img
    if not GAME_BEGIN and not EFFECT_LOOP then
        sx = .6
        sy = .6
        y = BORDER + MAP_Y*TILESIZE + 30
        x = love.graphics.getWidth()/2 - 20
        img = IMG_GOAL
        w = img:getWidth()
        h = img:getHeight()
        color = COLOR(0,0,0)
        text = GOAL
        score = IMG(img, x, y, w, h, sx, sy, text, font, color)
        I_T["goal_value"] = score
    end

    --MAP BORDER--

    if not GAME_BEGIN and not EFFECT_LOOP then
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

--Return functions
return draw
