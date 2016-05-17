--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"
Camera    = require "hump.camera"


--MY MODULES
local Draw      = require "draw"
local Util      = require "util"
local Button    = require "button"
local Img       = require "img"
local TextBox   = require "textbox"
local Text      = require "text"
local Player    = require "player"
local RGB       = require "rgb"
local Filter    = require "filter"
local Particle  = require "particle"
local FX        = require "fx"
local Shapes    = require "shapes"
local CPU       = require "cpu"
local Map       = require "map"
local Setup     = require "setup"
local UD        = require "utildraw"
local Primitive = require "primitive"

--GAMESTATES
GS_MENU     = {}
GS_SETUP    = {}
GS_GAME     = {}
GS_PAUSE    = {}
GS_GAMEOVER = {}

function love.load()

    Setup.config()

    Gamestate.registerEvents()
    Gamestate.switch(GS_SETUP)

end

function love.mousepressed(x, y, button, istouch)
    
    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
        Img.checkCollision(x,y)
    end

end

---------------
--STATE : SETUP
---------------
function GS_SETUP:enter()
    
    Util.clearAllTables()

    Draw.setup_setup()

end

--When leaving, clears tables with buttons and textboxes
function GS_SETUP:leave()
    
    Util.clearAllTables()

    Setup.match()

end

function GS_SETUP:draw()
    
    Draw.setup_state()

end

function GS_SETUP:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)

    --Update "real-time" stuff
    Particle.update(dt)
    Util.glowEPS_2(dt) --Make setup stuff glow
    Util.updateBG(dt)

end

function GS_SETUP:keypressed(key)

    Util.defaultKeyPressed(key)

    if  key == "return" then
        MATCH_BEGIN = true
        Gamestate.switch(GS_GAME)

    --Buttons shortcuts
    elseif key == 'right' then
        BI_T["n_player_up"].func()
    elseif key == 'left' then
        BI_T["n_player_down"].func()
    elseif key == 'up' then
        BI_T["goal_up"].func()
    elseif key == 'down' then
        BI_T["goal_down"].func()
    end

end

---------------
--STATE : GAME
---------------

function GS_GAME:enter()
    
    Setup.game()

    Draw.game_setup()

end

function GS_GAME:leave()

    Util.clearAllTables("inGame")

end

function GS_GAME:update(dt)
    local cont

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)
    Util.updateBG(dt)
    

    if GAME_BEGIN then

        Util.tick(dt)
    
        --Count how many players are alive
        cont = Util.countPlayers()
        if cont == 0 or (cont == 1 and not DEBUG) then
            Gamestate.switch(GS_GAMEOVER)
        end
        
    end

end

function GS_GAME:draw()
    
    Draw.game_state()

end

function GS_GAME:keypressed(key)
    local i

    Util.defaultKeyPressed(key)

    if key == 'r' and DEBUG then
        GAME_SETUP = false
        Util.clearAllTables("gameover")
        Gamestate.switch(GS_GAME)
    end

    
    --MOVEMENT (doesn't allow the player to move backwards)
    
    i = WASD_PLAYER
    
    if i ~= 0 then  
        if     key == 'w' and P_T[i].dir ~= 4 then --move up
            P_T[i].nextdir = 2
        elseif key == 'a' and P_T[i].dir ~= 3 then --move left
            P_T[i].nextdir = 1
        elseif key == 's' and P_T[i].dir ~= 2 then --move down
            P_T[i].nextdir = 4
        elseif key == 'd' and P_T[i].dir ~= 1 then --move right
            P_T[i].nextdir = 3
        end
    end

    i = ARROWS_PLAYER 

    if i ~= 0 then
        if     key == 'up'    and P_T[i].dir ~= 4 then --move up
            P_T[i].nextdir = 2
        elseif key == 'left'  and P_T[i].dir ~= 3 then --move left
            P_T[i].nextdir = 1
        elseif key == 'down'  and P_T[i].dir ~= 2 then --move down
            P_T[i].nextdir = 4
        elseif key == 'right' and P_T[i].dir ~= 1 then --move right
            P_T[i].nextdir = 3
        end
    end

end

---------------
--STATE : PAUSE
---------------

function GS_PAUSE:enter()

    Draw.pause_setup()

end

function GS_PAUSE:leave()

    Util.clearAllTables("inGame")
    
end

function GS_PAUSE:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)

end

function GS_PAUSE:draw()
    
    Draw.pause_state()

end

function GS_PAUSE:keypressed(key)

    Util.defaultKeyPressed(key)

end

------------------
--STATE : GAMEOVER
------------------

function GS_GAMEOVER:enter()

    Util.checkWinner()

    Draw.gameover_setup()

end

function GS_GAMEOVER:leave()

    Util.clearAllTables("gameover")
    
end

function GS_GAMEOVER:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)

    --Update "real-time" stuff
    Particle.update(dt*0.5)
    Util.updateBG(dt)

end

function GS_GAMEOVER:draw()
    
    Draw.gameover_state()

end

function GS_GAMEOVER:keypressed(key)

    Util.defaultKeyPressed(key)

    if key == 'return' then
        GAME_SETUP = false
        if MATCH_BEGIN == false then
            Gamestate.switch(GS_SETUP)
        else            
            Gamestate.switch(GS_GAME)
        end
    end

end

--------------------
--DEBUG
--------------------

function love.update(dt)
end

function love.draw()
end

--------------------
--ZOEIRAZOEIRAZOEIRA
--------------------

function love.keypressed(key)
   
    if key == "0" then
        Util.zoera("mayts")
    elseif key == '8' then
        for i, v in pairs(P_T) do
            print("Player "..v.number..":"..v.color_id)
        end
        print("---")
    elseif key == '7' then
        for i, v in pairs(C_MT) do
            print("CM "..i..":"..v)
        end
        print("---")
    end
end
