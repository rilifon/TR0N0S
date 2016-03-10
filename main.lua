--HUMP STUFF

Gamestate = require "hump.gamestate"
Timer = require "hump.timer"

--MY MODULES

local Draw   = require "draw"
local Update = require "update"

--GAMESTATES
local menu = {}
local game = {}
local pause = {}
local gameover = {}

function love.load()

    --RANDOM SEED
    math.randomseed( os.time() )

    --GLOBAL VARIABLES
    DEBUG = false


    
    game_setup = false
    MAX_PLAYERS = 2
    MAX_COUNTDOWN = 3
    TIMESTEP = 0.04   --Time between each game step
    TILESIZE = 15     --Size of the game's tile
    BORDER = TILESIZE --Border of the game map
    MARGIN = 12       --Size of margin for players' inicial position
    map = {}
    map_x = 50
    map_y = 50

    --WINDOW CONFIG
    success = love.window.setMode(TILESIZE*map_x + 2*BORDER, TILESIZE*map_y + 2*BORDER, {borderless = true})


    Gamestate.registerEvents()
    Gamestate.switch(game)
end

---------------
--STATE : GAME
---------------

function game:enter()
    
    --Setup game
    if not game_setup then
        countdown = MAX_COUNTDOWN
        Inicial_Timer = Timer.new()
        game_begin = false
        step = 0
        
        --Reset map
        for i=1,map_x do
            map[i] = {}
            for j=1,map_y do
                map[i][j] = 0
            end
        end
        
        local p_x = 1
        local p_y = 1

        --Setup players
        players = {}
        for i=1,MAX_PLAYERS do
            
            players[i] = {}
            
            --Get random positions for all players
            local is_rand = false
            while is_rand == false do
                p_x = math.random(map_x-2*MARGIN)+MARGIN
                p_y = math.random(map_y-2*MARGIN)+MARGIN
                is_rand = true
                --Iterate in all other players and checks for a valid position
                for j=1,i-1 do
                    if(p_x == players[j].x and p_y == players[j].y) then
                        is_rand = false
                    end
                end
            end

            players[i].x = p_x  --Player x position
            players[i].y = p_y  --Player y position

            players[i].dir     = 0 --Player current direction
            players[i].nextdir = 0 --Player next direction

            players[i].dead = false

        end
        game_setup = true
        StartCountdown()

    end
end

function StartCountdown()
    
    local time = 0
    local cd = countdown
    Inicial_Timer.during(MAX_COUNTDOWN, function(dt)
                                local time = time+dt
                                cd = cd - time 
                                countdown = math.floor(cd)+1
                            end,
                            function()
                                game_begin = true
                            end)
end

function game:update(dt)

    --Handles timers
    Inicial_Timer.update(dt)
    

    if game_begin then
            
        --Players go right the the start if they dont chose a direction
        local did_that = false
        if not did_that then
            for k=1,MAX_PLAYERS do
                if players[k].dir     == 0 then players[k].dir     = 3 end
                if players[k].nextdir == 0 then players[k].nextdir = 3 end
            end
            did_that = true
        end

        Update.tick(dt)
    
        --Count how many players are alive
        local cont = 0
        winner = 0
        for i=1,MAX_PLAYERS do
            if players[i].dead == false then
                cont = cont+1
                winner = i
            end
        end
        
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
    if     key == 'w' and players[1].dir ~= 4 then --move up
        players[1].nextdir = 2
    elseif key == 'a' and players[1].dir ~= 3 then --move left
        players[1].nextdir = 1
    elseif key == 's' and players[1].dir ~= 2 then --move down
        players[1].nextdir = 4
    elseif key == 'd' and players[1].dir ~= 1 then --move right
        players[1].nextdir = 3
    end
    if     key == 'up'    and players[2].dir ~= 4 then --move up
        players[2].nextdir = 2
    elseif key == 'left'  and players[2].dir ~= 3 then --move left
        players[2].nextdir = 1
    elseif key == 'down'  and players[2].dir ~= 2 then --move down
        players[2].nextdir = 4
    elseif key == 'right' and players[2].dir ~= 1 then --move right
        players[2].nextdir = 3
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
    end

end