local Map = require "map"
local FX  = require "fx"
local RGB = require "rgb"

--MODULE FOR SETUP STUFF--

local setup = {}

--------------------
--SETUP FUNCTIONS
--------------------

--Set game's global variables, random seed and window configuration
function setup.config()
    local p1, p2      --Player 1 and 2
    local color, rgb_b, rgb_h, color_id  --Color for body and head
    local ratio, sucess

    --IMAGES
    
    --The Pixel
    PIXEL = love.graphics.newImage("assets/pixel.png")
    --Button
    IMG_BUT_PLUS = love.graphics.newImage("assets/button_plus.png")
    IMG_BUT_MINUS = love.graphics.newImage("assets/button_minus.png")
    IMG_BUT_MINUS_INV = love.graphics.newImage("assets/button_minus_inv.png")
    --Regular images
    IMG_DEFAULT = love.graphics.newImage("assets/default_img.png")
    IMG_BORDER_TOP = love.graphics.newImage("assets/border_top.png")
    IMG_BORDER_BOT = love.graphics.newImage("assets/border_bot.png")
    IMG_BORDER_MAP = love.graphics.newImage("assets/map_border.png")
    IMG_SCORE      = love.graphics.newImage("assets/score_img.png")
    IMG_VAR        = love.graphics.newImage("assets/var_img.png")
    IMG_GOAL       = love.graphics.newImage("assets/goal_img.png")
    IMG_COM        = love.graphics.newImage("assets/default_command_img.png")
    IMG_COLOR      = love.graphics.newImage("assets/button_color_change.png")
    IMG_TEXT       = love.graphics.newImage("assets/button_text_change.png")
    --Background
    IMG_BG = love.graphics.newImage("assets/background.png")
    BG_X = -954 --Background x position
    --RANDOM SEED

    math.randomseed( os.time() )
    math.random(); math.random(); --Improves random

    --GLOBAL VARIABLES

    DEBUG = false      --DEBUG mode status
    DEBUG_DRAW = false --DEBUG mode status that shows players rectangles
    HEAD  = 9 --Value that represents a player head in the game map
    PLAYER_IS_TYPING = false --Represents if a player is in a state of typing
    PLAYER_TYPING = nil --Player that is having his name changed
    BUTTON_LOCK   = false --If true, buttons won't work
    
    --MATCH/GAME SETUP VARS

    MATCH_BEGIN = false --If is in a current match
    GAME_SETUP = false  --Inicial setup for each game
    GAME_BEGIN = false  --If is in a current game
    GOAL = 3            --Score goal that will be set in the match
    MAX_PLAYERS = 8     --Max number of players in a game
    N_PLAYERS = 2       --Number of players playing
    
    --CONTROL VARS

    WASD_PLAYER = 1     --Player using wasd keys
    ARROWS_PLAYER = 2   --Player using arrow keys
    
    --TIME VARS

    MAX_COUNTDOWN = 3   --Countdown in the beggining of each game
    COUNTDOWN = 0       --Current countdown
    TIMESTEP = 0.04     --Time between each game step
    STEP     = 0        --Step Counter

    --MAP VARS

    TILESIZE = 10       --Size of the game's tile
    HUDSIZE = 100       --Size of window dedicated for HUD
    BORDER = 120        --Border of the game map
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

    --BUTTONS FLAGS
    N_PLAYER_UP_FLAG = false    --if n_player_up button is pressed
    N_PLAYER_DOWN_FLAG = false  --if n_player_down button is pressed
    GOAL_UP_FLAG = false        --if goal_up button is pressed
    GOAL_DOWN_FLAG = false      --if goal_down button is pressed

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
    HUD_T  = {}  --HUD Table
    PBOX_T = {}  --Players Box Table
     
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
    MAP_COLOR = COLOR(color.r, color.g, color.b, color.a)

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
    font_but_ml = love.graphics.newFont( "assets/vanadine_bold.ttf", 40) --Font for buttons, large size
    font_but_mml = love.graphics.newFont( "assets/vanadine_bold.ttf", 32) --Font for buttons, large size
    font_but_m = love.graphics.newFont( "assets/vanadine_bold.ttf", 30) --Font for buttons, medium size
    font_reg_m = love.graphics.newFont( "assets/FUTUVA.ttf", 30) --Font for regular text, medium size
    font_reg_ms = love.graphics.newFont( "assets/FUTUVA.ttf", 23) --Font for regular text, medium size
    font_reg_s = love.graphics.newFont( "assets/FUTUVA.ttf", 16) --Font for regular text, small size
    love.graphics.setFont(font_reg_m)

    --CAMERA
    --Set camera position to center of screen
    CAM = Camera(love.graphics.getWidth()/2, love.graphics.getHeight()/2)


    --EFFECTS
    EFFECT_LOOP = false

    --Creates first two players with random colors

    --Player 1
    color_id = RGB.randomBaseColor()
    rgb_b = RGB.randomColor(color_id)
    rgb_h = RGB.randomDarkColor(rgb_b)
    p1   = PLAYER(1, false, nil, nil, nil, nil, rgb_b, rgb_h)
    p1. control = "WASD"
    p1.color_id = color_id
    table.insert(P_T, p1)

    --Player 2
    color_id = RGB.randomBaseColor()
    rgb_b = RGB.randomColor(color_id)
    rgb_h = RGB.randomDarkColor(rgb_b)
    p2   = PLAYER(2, false, nil, nil, nil, nil, rgb_b, rgb_h)
    p2.control = "ARROWS"
    p2.color_id = color_id
    table.insert(P_T, p2)
    
    

end

--Setup a new match, setting all scores to zero
function setup.match()

    EFFECT_LOOP = false

    GROWING = true
    EPS  = MIN_EPS

    for i, p in ipairs(P_T) do
        p.score = 0
    end

end

 --Setup a new game
function setup.game()
    
    if not GAME_SETUP then
        COUNTDOWN = MAX_COUNTDOWN --Setup countdown

        GAME_BEGIN = false
        STEP = 0
        winner = 0
        
        Map.reset()
        
        setup.players()

        GAME_SETUP = true
        Game_Timer.after(N_PLAYERS*.6 - .4, Map.startCountdown)
    end

end


--Setup all players
function setup.players()
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

        Game_Timer.after(p.number*.4, 
            function()
                FX.playerEntrance(p)
            end
        )

    end

end

--Return setup functions
return setup