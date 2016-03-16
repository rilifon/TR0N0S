--HUMP STUFF
Gamestate = require "hump.gamestate"
Timer     = require "hump.timer"
Class     = require "hump.class"


--MY MODULES
local Draw    = require "draw"
local Util    = require "util"
local Button  = require "button"
local TextBox = require "textbox"
local Player  = require "player"
local Rgb     = require "rgb"


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
    if not main_setup then
        Player.setup()
        Button.setup()
        TextBox.setup()
    end
end


function setup:draw()
    
    Draw.setup()

    Draw.HUD()
end

function setup:keypressed(key)

    --CHANGE STATES
    if      key == 'q' then
        love.event.quit()
    elseif  key == "return" then
        Gamestate.switch(game)
    elseif key == 'b' then
        if DEBUG then DEBUG = false else DEBUG = true end
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

end

function game:update(dt)

    --Handles timers
    Inicial_Timer.update(dt)
    

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
    

    Draw.map()

    if not game_begin then
        Draw.playerIndicator()
    end
    
    Draw.HUD()

    if not game_begin then
        Draw.countdown()
    end

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
        if DEBUG then DEBUG = false else DEBUG = true end
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

function pause:draw()
    
    Draw.map()

    Draw.pause()

    Draw.HUD()

end

function pause:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
    elseif key == 'p' then
        Gamestate.switch(game)
    elseif key == 'b' then
        if DEBUG then DEBUG = false else DEBUG = true end
    end

end

------------------
--STATE : GAMEOVER
------------------

function gameover:draw()
    
    Draw.map()

    Draw.gameover()

    Draw.HUD()
end

function gameover:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
    elseif key == 'r' then
        game_setup = false
        Gamestate.switch(game)
    elseif key == 'b' then
        if DEBUG then DEBUG = false else DEBUG = true end
    end

end