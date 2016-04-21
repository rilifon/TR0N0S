--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"


--MY MODULES
local Draw     = require "draw"
local Util     = require "util"
local Button   = require "button"
local Img      = require "img"
local TextBox  = require "textbox"
local Text     = require "text"
local Player   = require "player"
local Rgb      = require "rgb"
local Filter   = require "filter"
local Particle = require "particle"
local FX       = require "fx"
local Shapes   = require "shapes"

--GAMESTATES
local menu     = {}
local setup    = {}
local game     = {}
local pause    = {}
local gameover = {}

function love.load()

   -- love.graphics.setBackgroundColor(255,255,255)

    Util.configGame()

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

    Util.setupMatch()

end

function setup:draw()
    
    Draw.setup_state()

end

function setup:update(dt)

    --Handles timers
    Game_Timer.update(dt)

    --Update "real-time" stuff
    Particle.update(dt)
    Util.glowEPS_2(dt) --Make setup stuff glow

end

function setup:keypressed(key)

    --CHANGE STATES
    if      key == 'q' then
        Util.quit()
    elseif  key == "return" then
        MATCH_BEGIN = true
        Gamestate.switch(game)
    elseif key == 'b' then
        Draw.toggleDebug()
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
    
    if button == 1 then
        Button.checkCollision(x,y)
        Img.checkCollision(x,y)
    end

end

---------------
--STATE : GAME
---------------

function game:enter()
    
    Util.setupGame()

    Draw.game_setup()

end

function game:leave()

    Util.clearAllTables("inGame")

end

function game:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    Color_Timer.update(dt)
    

    if game_begin then

        Util.tick(dt)
    
        --Count how many players are alive
        local cont = Util.countPlayers()
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

    --CHANGE STATES
    if key == 'q' then
        Util.quit()
    elseif key == 'p' and game_begin then
        Gamestate.switch(pause)
    elseif key == 'r' and DEBUG then
        game_setup = false
        Gamestate.switch(game)
    elseif key == 'b' then
        Draw.toggleDebug()
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

function pause:draw()
    
    Draw.pause_state()

end

function pause:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        Util.quit()
    elseif key == 'p' then
        Gamestate.switch(game)
    elseif key == 'b' then
        Draw.toggleDebug()
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

    --Update "real-time" stuff
    Particle.update(dt*0.5)

end

function gameover:draw()
    
    Draw.gameover_state()

end

function gameover:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        Util.quit()
    elseif key == 'return' then
        game_setup = false
        if MATCH_BEGIN == false then
            Gamestate.switch(setup)
        else            
            Gamestate.switch(game)
        end
    elseif key == 'b' then
        Draw.toggleDebug()
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
        Util.zoera()
    elseif key == "9" then
        for i = 1, map_x do
            for j = 1, map_y do
                io.write(map[i][j])
            end
            print("-")
        end
    end 

end
