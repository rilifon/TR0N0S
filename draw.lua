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
    SetupHUD_default("simple")

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
    goal_up = But_Img(img, x, y, w, h, sx, sy, "+", font, color_t, goal_up_func)
    BI_T["goal_up"] =  goal_up

    --Down button
    img = IMG_BUT_MINUS
    sx = 1
    sy = 1
    w = img:getWidth()
    h = img:getHeight()
    y = y + h - 20
    goal_down = But_Img(img, x, y, w, h, sx, sy, "-", font, color_t, goal_down_func)
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
        text = "(esc)ape"
    elseif mode == "complete" then
        text = "(esc)ape     (p)ause"
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


    --Draw Goal value img
    if not GAME_BEGIN and not EFFECT_LOOP then
        sx = .6
        sy = .6
        y = BORDER + MAP_Y*TILESIZE + 30
        x = love.graphics.getWidth()/2 - 20
        img = IMG_VAR
        color = COLOR(0,0,0)
        text = ""
        score = IMG(img, x, y, w, h, sx, sy, text, font, color)
        I_T["goal_value"] = score
    end
    
    --Draw Goal value
    y = BORDER + MAP_Y*TILESIZE + 54
    x = love.graphics.getWidth()/2 + 27
    sx = 1.2
    sy = 1.2
    color = COLOR(0,0,0)
    text = GOAL
    txt = TXT(x, y, text, font, color, sx, sy)
    TXT_T["goal_value_txt"] = txt

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
