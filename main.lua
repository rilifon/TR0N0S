--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"


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
local menu     = {}
local setup    = {}
local game     = {}
local pause    = {}
local gameover = {}

function love.load()

   -- love.graphics.setBackgroundColor(255,255,255)

    Setup.config()

    Gamestate.registerEvents()
    Gamestate.switch(setup)

end



---------------
--STATE : SETUP
---------------
function setup:enter()
    
    Draw.setup_setup()

end

--When leaving, clears tables with buttons and textboxes
function setup:leave()
    
    Util.clearAllTables()

    Setup.match()

end

function setup:draw()
    
    Draw.setup_state()

end

function setup:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)

    --Update "real-time" stuff
    Particle.update(dt)
    Util.glowEPS_2(dt) --Make setup stuff glow
    Util.updateBG(dt)

end

function setup:keypressed(key)

    Util.defaultKeyPressed(key)

    if  key == "return" then
        MATCH_BEGIN = true
        Gamestate.switch(game)

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

function setup:mousepressed(x, y, button, istouch)
    
    if button == 1 then  --Left mouse button
        Button.checkCollision(x,y)
        Img.checkCollision(x,y)
    end

end

---------------
--STATE : GAME
---------------

function game:enter()
    
    Setup.game()

    Draw.game_setup()

end

function game:leave()

    Util.clearAllTables("inGame")

end

function game:update(dt)
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
            Gamestate.switch(gameover)
        end
        
    end

end

function game:draw()
    
    Draw.game_state()

end

function game:keypressed(key)
    local i

    Util.defaultKeyPressed(key)

    if key == 'p' and GAME_BEGIN then
        Gamestate.switch(pause)
    elseif key == 'r' and DEBUG then
        GAME_SETUP = false
        Gamestate.switch(game)
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

function pause:enter()

    Draw.pause_setup()

end

function pause:leave()

    Util.clearAllTables("inGame")
    
end

function pause:update(dt)

    Color_Timer.update(dt)

end

function pause:draw()
    
    Draw.pause_state()

end

function pause:keypressed(key)

    
    Util.defaultKeyPressed(key)
    
    if key == 'p' then
        Gamestate.switch(game)
    end

end

------------------
--STATE : GAMEOVER
------------------

function gameover:enter()

    Util.checkWinner()

    Draw.gameover_setup()

end

function gameover:leave()

    Util.clearAllTables()
    
end

function gameover:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)

    --Update "real-time" stuff
    Particle.update(dt*0.5)
    Util.updateBG(dt)

end

function gameover:draw()
    
    Draw.gameover_state()

end

function gameover:keypressed(key)

    Util.defaultKeyPressed(key)

    if key == 'return' then
        GAME_SETUP = false
        if MATCH_BEGIN == false then
            Gamestate.switch(setup)
        else            
            Gamestate.switch(game)
        end
    end

end

--------------------
--DEBUG
--------------------

function game:mousepressed(x, y, button, istouch)
end

function love.update(dt)
end

function love.draw()
end

--------------------
--ZOEIRAZOEIRAZOEIRA
--------------------

function love.keypressed(key)
   
    if key == "0" then
        Util.zoera("omar")
    elseif key == "9" then
        for i = 1, MAP_X do
            for j = 1, MAP_Y do
                io.write(MAP[i][j])
            end
            print("-")
        end
    elseif key == '8' then
        print("--")
        for i, box in pairs(BOX_T) do
            print("x "..box.x.." y "..box.y.." w "..box.w.." h "..box.h)
        end
        print("--")
    end  

end
