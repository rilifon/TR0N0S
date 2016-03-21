--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"


--MY MODULES
local Draw     = require "draw"
local Util     = require "util"
local Button   = require "button"
local TextBox  = require "textbox"
local Text     = require "text"
local Player   = require "player"
local Rgb      = require "rgb"
local Filter   = require "filter"
local Particle = require "particle"


--GAMESTATES
local menu     = {}
local setup    = {}
local game     = {}
local pause    = {}
local gameover = {}

function love.load()

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

function setup:keypressed(key)

    --CHANGE STATES
    if      key == 'q' then
        love.event.quit()
    elseif  key == "return" then
        MATCH_BEGIN = true
        Gamestate.switch(game)
    elseif key == 'b' then
        Draw.toggleDebug()
    end
end

function setup:mousepressed(x, y, button, istouch)
    if button == 1 then
        Button.checkCollision(x,y)
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

    Util.clearAllTables("notPart")

end

function game:update(dt)

    --Handles timers
    Game_Timer.update(dt)
    

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

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
    elseif key == 'p' and game_begin then
        Gamestate.switch(pause)
    elseif key == 'r' and DEBUG then
        game_setup = false
        Gamestate.switch(game)
    elseif key == 'b' then
        Draw.toggleDebug()
    end

    
    --MOVEMENT (doesn't allow the player to move backwards)
    
    local i = WASD_PLAYER   
    if     key == 'w' and P_T[i].dir ~= 4 then --move up
        P_T[i].nextdir = 2
    elseif key == 'a' and P_T[i].dir ~= 3 then --move left
        P_T[i].nextdir = 1
    elseif key == 's' and P_T[i].dir ~= 2 then --move down
        P_T[i].nextdir = 4
    elseif key == 'd' and P_T[i].dir ~= 1 then --move right
        P_T[i].nextdir = 3
    end

    local i = ARROWS_PLAYER 
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

---------------
--STATE : PAUSE
---------------

function pause:enter()

    Draw.pause_setup()

end

function pause:leave()

    Util.clearAllTables("notPart")
    
end

function pause:draw()
    
    Draw.pause_state()

end

function pause:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
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

    Util.setupWinner()

    Draw.gameover_setup()

end

function gameover:leave()

    Util.clearAllTables()
    
end

function gameover:draw()
    
    Draw.gameover_state()

end

function gameover:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
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

--------------------
--ZOEIRAZOEIRAZOEIRA
--------------------

function love.keypressed(key)
    if key == "0" then
        Util.mayts()
    end
end