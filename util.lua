local Particle = require "particle"
local RGB      = require "rgb"
local FX       = require "fx"
local CPU      = require "cpu"
local Map      = require "map"

--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed and window configuration
function util.configGame()
    local P_1, P_2      --Player 1 and 2
    local color, rgb_b, rgb_h, color_id  --Color for body and head
    local ratio

    --IMAGES
    
    --The Pixel
    PIXEL = love.graphics.newImage("assets/pixel.png")
    --Button
    bt_img_plus = love.graphics.newImage("assets/button_plus.png")
    bt_img_minus = love.graphics.newImage("assets/button_minus.png")
    --Regular images
    bt_img = love.graphics.newImage("assets/default_img.png")
    border_top_img = love.graphics.newImage("assets/border_top.png")
    border_bot_img = love.graphics.newImage("assets/border_bot.png")
    --Background
    bg_img = love.graphics.newImage("assets/background.png")
    BG_X = -954 --Background x position
    --RANDOM SEED


    math.randomseed( os.time() )
    math.random(); math.random(); --Improves random

    --GLOBAL VARIABLES

    DEBUG = false      --DEBUG mode status
    HEAD  = 9
    
    --MATCH/GAME SETUP VARS

    game_setup = false  --Inicial setup for each game
    GOAL = 3            --Score goal that will be set in the match
    MATCH_BEGIN = false --If is in a current match
    MAX_PLAYERS = 8     --Max number of players in a game
    N_PLAYERS = 2       --Number of players playing
    
    --CONTROL VARS

    WASD_PLAYER = 1     --Player using wasd keys
    ARROWS_PLAYER = 2   --Player using arrow keys
    
    --TIME VARS

    MAX_COUNTDOWN = 4   --Countdown in the beggining of each game
    TIMESTEP = 0.04     --Time between each game step

    --MAP VARS

    TILESIZE = 10       --Size of the game's tile
    HUDSIZE = 100       --Size of window dedicated for HUD
    BORDER = 90         --Border of the game map
    MARGIN = 6          --Size of margin for players' inicial position
    
    MAP = {}            --Game map
    MAP_X = 65          --Map x size (in tiles)
    MAP_Y = 65          --Map y size (in tiles)
    for i=1,MAP_Y do    --Creates the map
        MAP[i] = {}
        for j=1,MAP_X do
            MAP[i][j] = 0
        end
    end

    AUX_MAP= {}        --Auxiliar map to find rectangles
    for i=1,MAP_Y do   --Creates the auxiliar map
        AUX_MAP[i] = {}
        for j=1,MAP_X do
            AUX_MAP[i][j] = 0
        end
    end

    --GLOW FOR TILES EFFECT

    EPS      = 6      --Range of players glow effect
    GROWING  = false  --If eps will be growing or not 
    MAX_EPS  = 12     --Max value for eps
    MIN_EPS  = 6      --Min value for eps

    --GLOW FOR SETUP EFFECT

    EPS_2      = 45      --Range of players glow effect
    GROWING_2  = true  --If eps will be growing or not 
    MAX_EPS_2  = 70     --Max value for eps
    MIN_EPS_2  = 30     --Min value for eps

        
    --TIMERS

    if not Game_Timer then
        Game_Timer = Timer.new()  --Timer for all game-related timing stuff
    end

    if not Color_Timer then
        Color_Timer = Timer.new()  --Timer for all color-related timing stuff
    end

    --SHADERS
    SHADER = nil --Current shader

    --Shader for drawing glow effect
    Glow_Shader = love.graphics.newShader[[
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );
            vec2 center = vec2(0.5,0.5);
            number grad = 0.7;
            number dist = distance(center, texture_coords);
            if(dist <= 0.5){
                color.a = color.a * 1-(dist/0.5);
                color.r = color.r * grad;
                color.g = color.g * grad;
                color.b = color.b * grad;
                return pixel*color;
            }
        }
    ]]


    --Shader for drawing background effect
    BG_Shader = love.graphics.newShader[[
        extern number width; //Screen width
        extern number height; //Screen height
        vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords ){
            vec4 pixel = Texel(texture, texture_coords );
            vec2 center = vec2(width/2,height/2);
            number dist = distance(center, screen_coords);
            dist = dist / ((width+height)/2.5);
            color.a = color.a * dist;
            color.r = color.r;
            color.g = color.g;
            color.b = color.b;
            return pixel*color;
        }
    ]]

    --DRAWING TABLES

    TB_T   = {}  --Default TextBox table
    B_T    = {}  --Default Button table
    BI_T   = {}  --Default Button with Images table
    I_T    = {}  --Images table
    TXT_T  = {}  --Default Text table
    F_T    = {}  --Filter table
    PB_T   = {}  --Players Button table
    PART_T = {}  --Particles table
    FX_T   = {}  --Effects Table
    BOX_T  = {}  --Box Table
    HD_T   = {}  --Map Table (contain all head tiles)
    GLOW_T = {}  --Map Table (contain all glow tiles)
     
    --COLOR TABLES

    --All base colors players can have
    C_T    = {COLOR(255,154,54),  COLOR(255,242,54),  COLOR(161,247,47),
              COLOR(51,219,245),  COLOR(51,100,245),  COLOR(152,47,237),
              COLOR(240,43,210),  COLOR(240,43,102),  COLOR(255,0,0),
              COLOR(18, 173,42)}
    --Base colors mapping table
    C_MT   = {0,0,0,0,0,0,0,0,0}  

    
    --All base colors map background can have
    MC_T   = {COLOR(250,107,12), COLOR(250,81,62), COLOR(240,60,177), COLOR(180,18,201)}
    --Color for the map (initial random color)
    color = MC_T[math.random(#MC_T)]
    MAP_COLOR = COLOR(color.r, color.g, color.b)

    --Starts background transition
    MAP_COLOR.a = 0
    FX.smoothColor(MAP_COLOR, COLOR(MAP_COLOR.r, MAP_COLOR.g, MAP_COLOR.b, 255), 2, 'linear')
    Map.backgroundTransition()

    --OTHER TABLES

    P_T   = {}  --Players table

    H_T = {}    --Timer's handle table

    --WINDOW CONFIG
    success = love.window.setMode(TILESIZE*MAP_X + 2*BORDER, TILESIZE*MAP_Y + 2*BORDER, {borderless = not DEBUG})
    BG_Shader:send("width", love.graphics.getWidth()) --Window width
    BG_Shader:send("height", love.graphics.getHeight()) --Window height

    --FONT STUFF
    font_but_l = love.graphics.newFont( "assets/FUTUVA.ttf", 50) --Font for buttons, large size
    font_but_m = love.graphics.newFont( "assets/vanadine_bold.ttf", 30) --Font for buttons, medium size
    font_reg_m = love.graphics.newFont( "assets/FUTUVA.ttf", 30) --Font for regular text, medium size
    font_reg_s = love.graphics.newFont( "assets/FUTUVA.ttf", 16) --Font for regular text, small size
    love.graphics.setFont(font_reg_m)
    
    --Creates first two players with random colors

    --Player 1
    color_id = RGB.randomBaseColor()
    rgb_b = RGB.randomColor(color_id)
    rgb_h = RGB.randomDarkColor(rgb_b)
    P_1   = PLAYER(1, false, nil, nil, nil, nil, rgb_b, rgb_h, false, nil, "WASD")
    P_1.color_id = color_id
    table.insert(P_T, P_1)

    --Player 2
    color_id = RGB.randomBaseColor()
    rgb_b = RGB.randomColor(color_id)
    rgb_h = RGB.randomDarkColor(rgb_b)
    P_2   = PLAYER(2, false, nil, nil, nil, nil, rgb_b, rgb_h, false, nil, "ARROWS")
    P_2.color_id = color_id
    table.insert(P_T, P_2)
    

end

--Setup a new match, setting all scores to zero
function util.setupMatch()

    GROWING = true
    EPS  = MIN_EPS

    for i, p in ipairs(P_T) do
        p.score = 0
    end

end

 --Setup a new game
function util.setupGame()
    
    if not game_setup then
        countdown = MAX_COUNTDOWN --Setup countdown

        game_begin = false
        step = 0
        winner = 0
        
        Map.reset()
        
        setupPlayers()

        game_setup = true
        StartCountdown()
    end

end


--Setup all players
function setupPlayers()
    local p_x, p_y, is_rand, color, tile, p_margin
        
    p_margin = 6
        
    for i, p in ipairs(P_T) do

        --Get random positions for all players
        is_rand = false
        while is_rand == false do
            p_x = math.random(MAP_X-2*MARGIN)+MARGIN
            p_y = math.random(MAP_Y-2*MARGIN)+MARGIN
            is_rand = true
            --Iterate in all other players and checks for a valid position distant enough
            for j=1,i-1 do
                if( p_x  <= P_T[j].x + p_margin and p_x  >= P_T[j].x - p_margin
                and p_y  <= P_T[j].y + p_margin and p_y  >= P_T[j].y - p_margin)
                then
                    is_rand = false
                end
            end
        end

        p.x = p_x  --Player x position
        p.y = p_y  --Player y position

        p.dir     = nil --Player current direction
        p.nextdir = nil --Player next direction

        p.dead = false --ITS ALIVE!

        p.side = nil --For cpu level 3

        MAP[p_y][p_x] = HEAD --Update first position

        
        --Update map with players head
        color = COLOR(p.h_color.r, p.h_color.g, p.h_color.b, p.h_color.a)
        tile = TILE(p.x, p.y, color) --Creates a tile
        HD_T["mapx"..p.x.."y"..p.y] = tile

        --Add glow effect for head
        GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)

    end

end

------------------
--UPDATE FUNCTIONS
------------------

--Update step and all players position
function util.tick(dt)
    local t

    --Update "real-time" stuff

    Particle.update(dt) --Particle effect
    glowEPS(dt)         --Make tiles glow
    
    --Update "timestep" stuff
    step = math.min(TIMESTEP, step + dt)
    if step >= TIMESTEP then    

        UpdateCPU()

        UpdateHuman()

        --Get players bodies
        Map.getRectangles()

        --Reset step counter
        step = 0
    end

end

--Updates cpu players position
function UpdateCPU()
    local x, y, dir

    for i, p in ipairs(P_T) do
        if not p.dead and p.cpu then
            dir = p.dir
            x = p.x
            y = p.y
            
            --Update map before moving
            MAP[y][x] = p.number


            --CPU LEVEL 1
            if p.level == 1 then

               dir = CPU.level_1(p)


            --CPU LEVEL 2
            elseif p.level == 2 then

               dir = CPU.level_2(p)

            --CPU LEVEL 3
            elseif p.level == 3 then

               dir = CPU.level_3(p)

            end


            --Get CPU next position
            if dir == 1 then
                x = math.max(1, x - 1)         --Left
            elseif dir == 2 then
                y = math.max(1, y-1)           --Up
            elseif dir == 3 then
                x = math.min(MAP_X, x+1)       --Right
            elseif dir == 4 then
                y = math.min(MAP_Y, y+1)       --Down
            end

            --Updates player direction
            p.dir = dir

            movePlayer(x,y,p)
        end
    end

end



--Updates non-cpu players positions
function UpdateHuman()
    local x, y, dir

    for i, p in ipairs(P_T) do
        if not p.dead and not p.cpu then
            dir = p.nextdir
            x = p.x
            y = p.y
            
            --Update map before moving
            MAP[y][x] = p.number

            --Move players 
            if dir == 1 then
                x = math.max(1, x - 1)         --Left
            elseif dir == 2 then
                y = math.max(1, y-1)           --Up
            elseif dir == 3 then
                x = math.min(MAP_X, x+1)       --Right
            elseif dir == 4 then
                y = math.min(MAP_Y, y+1)       --Down
            end

            --Updates player direction
            p.dir = dir

            movePlayer(x,y,p)
        end
    end

end

-----------------------
--USEFUL GAME FUNCTIONS
-----------------------

--Updates background position
function util.updateBG(dt)
    local t, max
    
    t = 60 --Speed to increase position
    max = 0

    BG_X = BG_X + dt * t

    --Cicles image to a suitable position
    if BG_X >= max then
        BG_X = -954
    end

end

function movePlayer(x,y,p)
    local c, x_,y_, color, tile, a, b

    --Remove player headbox
    HD_T["mapx"..p.x.."y"..p.y] = nil

    --Add glow effect for tile
    GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, p.b_color)


    for y_=p.y-1, p.y+1 do
        for x_=p.x-1,p.x+1 do
            if y_>=1 and y_<=MAP_Y and
               x_>=1 and x_<=MAP_X
            then
                if Map.isSurrounded(y_, x_) then
                    GLOW_T["mapx"..x_.."y"..y_] = nil
                end
            end
        end
    end


    --Creates a mini-explosion
    x_ = p.x*TILESIZE + BORDER - TILESIZE/2
    y_ = p.y*TILESIZE + BORDER - TILESIZE/2
    FX.particle_explosion(x_, y_, p.b_color, .5, 1, nil, nil, 1) --Create effect

    --Update player position
    p.x = x
    p.y = y


    CheckCollision(p)

    --Update map with player head
    MAP[p.y][p.x] = HEAD

    --Updates head box position
    if not p.dead then
        color = COLOR(p.h_color.r, p.h_color.g, p.h_color.b, p.h_color.a)
        HD_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)
    else
        color = COLOR(0,0,0)
        HD_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)
    end

    --Add glow effect for head
    GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)

end

--Checks collision between players and walls/another player
function CheckCollision(p)
    local color = COLOR(255,0,115)
    local x, y
    
    --Check collision with wall
    if MAP[p.y][p.x] >= 1 and MAP[p.y][p.x] <= HEAD then
        p.dead = true --Makes player dead
        
        x = p.x*TILESIZE + BORDER
        y = p.y*TILESIZE + BORDER
        FX.particle_explosion(x, y, color, nil, nil, nil, nil, nil, 2) --Create effect

    end

    --Check collision with other players
    for i, p2 in ipairs(P_T) do
        if p.number ~= p2.number then --Compare with different players
            if p.x == p2.x and p.y == p2.y then
                p.dead = true  --Makes inicial player dead
                p2.dead = true --Makes player2 dead

                x = p.x*TILESIZE + BORDER
                y = p.y*TILESIZE + BORDER
                FX.particle_explosion(x, y, color) --Create effect

            end
        end
    end

end

--Count how many players are alive and declare a winner
function util.countPlayers()
    
    cont = 0
    winner = 0

    for i, p in ipairs(P_T) do
        if p.dead == false then
            cont = cont+1
            winner = p.number
        end
    end

    return cont 
end


--Handles winner of every game, and checks if match is over
function util.checkWinner()
    
    if winner ~= 0 then
        p = P_T[winner]
        --Increses player score
        p.score = p.score + 1

        if p.score >= GOAL then
            MATCH_BEGIN = false    --End of match, a player has reached target score
        end
    end

end

---------------------
--COUNTDOWN FUNCTIONS
---------------------

--Start the countdown to start a game
function StartCountdown()
    local cd = countdown
    local t, rand
    
    time = 0
    Game_Timer.during(MAX_COUNTDOWN, 
        --Decreases countdown
        function(dt)
            
            t = time+dt
            cd = cd - t
            countdown = math.floor(cd)+1

        end,

        --After countdown, start game and fixes players positions
        function()

            RemovePlayerIndicator()

            game_begin = true
            --Players go at a random direction at the start if they dont chose any
            for i, p in ipairs(P_T) do
                rand = math.random(4)
                if p.dir     == nil then p.dir     = rand end
                if p.nextdir == nil then p.nextdir = rand end
            end

        end
    )

end


-----------------------------------
--PLAYER BUTTON/INDICATOR FUNCTIONS
-----------------------------------

function util.createPlayerButton(p)
    local font = font_but_m
    local color_b, color_t, cputext, controltext, pl
    local pb, box, x, y, w, h, w_cb, h_cb, tween

    w_cb = 40 --Width of head color box
    h_cb = 40 --Height of head color box

    --Fix case where a timer is rolling to remove the button and active
    -- the button and active transitions
    if H_T["h"..p.number] then

        --Remove timer related to removing player button
        Game_Timer.cancel(H_T["h"..p.number])
        H_T["h"..p.number] = nil

        --Remove timer related to changing playeer button alpha
        if PB_T["P"..p.number.."pb"] then
            Game_Timer.cancel(PB_T["P"..p.number.."pb"].h)
        end

        --Remove timer related to changing player head box alpha
        if TB_T["P"..p.number.."tb"] then
            Game_Timer.cancel(TB_T["P"..p.number.."tb"].h)
        end
        
    end

     if p.cpu then
            cputext = "CPU"
            controltext = "Level " .. p.level
        else
            cputext = "HUMAN"
            controltext = p.control
    end

    --Counting the perceptive luminance - human eye favors green color... 
    pl = 1 - ( 0.299 * p.b_color.r + 0.587 * p.b_color.g + 0.114 * p.b_color.b)/255;

    if pl < 0.5 then
        color_t = COLOR(0, 0, 0, 0)       --bright colors - using black font
    else
        color_t = COLOR(255, 255, 255, 0) --dark colors - using white font
    end

    color_b = COLOR(p.b_color.r, p.b_color.g, p.b_color.b, 0)

    --Creates player button
    w = 500
    h = 40
    x = (love.graphics.getWidth() - w - w_cb)/2
    y = 240 + 45*p.number
    pb = But(x, y, w, h,
                    "PLAYER " .. p.number .. " " .. cputext .. " (" .. controltext .. ")",
                    font, color_b, color_t, 
                    --Change players from CPU to HUMAN with a controller
                    function()
                        --Human with WASD controls, on click, becomes ARROWS if possible, else becomes CPU
                        if not p.cpu and p.control == "WASD" then
                            if ARROWS_PLAYER == 0 then
                                p.control = "ARROWS"
                                ARROWS_PLAYER = p.number
                                WASD_PLAYER = 0
                            else
                                p.cpu = true
                                p.level = 1
                                p.control = nil
                                WASD_PLAYER = 0
                            end

                        --Human with ARROWS controls, on click, becomes CPU Level1
                        elseif not p.cpu and p.control == "ARROWS" then
                            p.cpu = true
                            p.level = 1
                            p.control = nil
                            ARROWS_PLAYER = 0

                        --CPU Level different from 3, on click, becomes next level CPU
                        elseif p.cpu and p.level ~= 3 then
                            p.level = p.level + 1

                        --CPU Level3, on click, becomes WASD or ARROWS if possible. Else becomes CPU Level1
                        elseif p.cpu and p.level == 3 then
                            if WASD_PLAYER == 0 then
                                p.control = "WASD"
                                WASD_PLAYER = p.number
                                p.cpu = false
                                p.level = nil
                            elseif ARROWS_PLAYER == 0 then
                                p.control = "ARROWS"
                                ARROWS_PLAYER = p.number
                                p.cpu = false
                                p.level = nil
                            else
                                p.level = 1
                            end
                        end

                        --Update player text
                        if p.cpu then
                            cputext = "CPU"
                            controltext = "Level " .. p.level
                        else
                            cputext = "HUMAN"
                            controltext = p.control
                        end
                        PB_T["P"..p.number.."pb"].text =  "PLAYER " .. p.number .. " " .. cputext .. " (" .. controltext .. ")"

                    end)
    PB_T["P"..p.number.."pb"] =  pb

    --Creates players head color box
    x = x + w
    box = BOX(x, y, w_cb, h_cb, p.h_color)
    BOX_T["P"..p.number.."box"] = box

    --Transitions
    pb.b_color.a = 0
    pb.t_color.a = 0
    box.color.a = 0
    tween = 'linear'
    FX.smoothAlpha(pb.b_color, 255, .4, tween)
    FX.smoothAlpha(pb.t_color, 255, .6, tween)
    FX.smoothAlpha(box.color, 255, .5, tween)

end

function util.removePlayerButton(p)
    local duration = .2
    local pb, box

    pb  = PB_T["P"..p.number.."pb"]
    box = BOX_T["P"..p.number.."box"]
    
    --Fades out
    pb.b_color.a = 255
    pb.t_color.a = 255
    box.color.a  = 255
    FX.smoothAlpha(pb.b_color, 0, duration, 'linear')
    FX.smoothAlpha(pb.t_color, 0, duration, 'linear')
    FX.smoothAlpha(box.color, 0, duration, 'linear')
    
    H_T["h"..p.number] = Game_Timer.after(duration, 
        function()
            --Removes player button on setup screen
            PB_T["P"..p.number.."pb"] = nil
            BOX_T["P"..p.number.."box"] = nil
        end
    )
end


--Update players buttons on setup
function util.updatePlayersB()

    for i, p in ipairs(P_T) do

        util.createPlayerButton(p)

    end

end

--Remove all player indicator text
function RemovePlayerIndicator()

    for i, p in ipairs(P_T) do
        TXT_T["player"..p.number.."txt"] = nil
        if  p.control == "WASD" then
            TXT_T["WASD"] = nil
        elseif p.control == "ARROWS" then
            TXT_T["ARROWS"] = nil
        else
            TXT_T["CPU"..i] = nil
        end
    end

end

---------------------
--UTILITIES FUNCTIONS
---------------------

--Clears all elements in a table
function util.clearTable(T)
    
    if not T then return end --If table is empty
    --Clear T table
    for i, k in pairs (T) do
        T[i] = nil
    end

end

--Clear all buttons and textboxes tables
function util.clearAllTables(mode)
    
    util.clearTable(TB_T)

    util.clearTable(B_T)

    util.clearTable(BI_T)

    util.clearTable(I_T)

    util.clearTable(TXT_T)

    util.clearTable(PB_T)

    util.clearTable(F_T)


    if mode ~= "inGame" then
        util.clearTable(PART_T)
        util.clearTable(GLOW_T)
        util.clearTable(HD_T)
        util.clearTable(FX_T)
        util.clearTable(BOX_T)
    end

end

--REDO THESE FUNCTIONS
--Glow effect
function glowEPS(dt)
    local t
    
    t = 3
    if GROWING then
        EPS = EPS + t*dt
        if EPS >= MAX_EPS then
            GROWING = false
        end
    else
        EPS = EPS - t*dt
        if EPS <= MIN_EPS then
            GROWING = true
        end
    end

end

--Glow effect for setup
function util.glowEPS_2(dt)
    local t
    
    t = 20
    if GROWING_2 then
        EPS_2 = EPS_2 + t*dt
        if EPS_2 >= MAX_EPS_2 then
            GROWING_2 = false
        end
    else
        EPS_2 = EPS_2 - t*dt
        if EPS_2 <= MIN_EPS_2 then
            GROWING_2 = true
        end
    end

end

--------------------
--GLOBAL FUNCTIONS
--------------------

--Exit program
function util.quit()

    love.event.quit()

end
--------------------
--ZOEIRAZOEIRAZOEIRA 
--------------------

function util.zoera()
    local text = "omar"
    for i, v in pairs(TXT_T) do
        v.text = text
    end

    for i, v in pairs(TB_T) do
        v.text = text
    end

    for i, v in pairs(B_T) do
        v.text = text
    end


    for i, v in pairs(PB_T) do
        v.text = text
    end

end

--Return functions
return util