--HUMP STUFF

Gamestate = require "hump.gamestate"
Timer = require "hump.timer"

--MY MODULES

local Draw = require "draw"

--GAMESTATES
local menu = {}
local game = {}
local pause = {}
local gameover = {}

function love.load()

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

            players[i].x = p_x
            players[i].y = p_y

            players[i].dir = 0

            players[i].dead = false

            map[players[i].x][players[i].y] = i --Draw the inicial position
        end
        game_setup = true
        StartCountdown()

    end
end

function StartCountdown()
    local time = 0
    local cd = countdown
    Inicial_Timer.during(5, function(dt)
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

    if game_begin then
        
        
        --Players go right the the start if they dont chose a direction
        local did_that = false
        if not did_that then
            for k=1,MAX_PLAYERS do
                if players[k].dir == 0 then players[k].dir = 3 end
            end
            did_that = true
        end

        --Update step
        step = math.min(TIMESTEP, step + dt)
        if step >= TIMESTEP then    
            for i=1,MAX_PLAYERS do
                if players[i].dead == false then
                    local dir = players[i].dir
                    local x = players[i].x
                    local y = players[i].y

                    --Move players 
                    if dir == 1 then
                        x = math.max(1, x - 1)         --Left
                    elseif dir == 2 then
                        y = math.max(1, y-1)           --Up
                    elseif dir == 3 then
                        x = math.min(map_x, x+1)       --Right
                    elseif dir == 4 then
                        y = math.min(map_y, y+1)       --Down
                    end
                    --Update player position
                    players[i].x = x
                    players[i].y = y
                    --Check collision
                    if map[x][y] ~= 0 then
                        players[i].dead = true
                    --Draw map
                    else
                        map[x][y] = i
                    end
                end

            end
            step = 0
        end
    end
end

function game:draw()
    
    local p = 0 --Player in this tile

    Draw.map()

    --Draw players indicator
    if not game_begin then
        for i=1,map_x do
            for j=1,map_y do
                for k=1,MAX_PLAYERS do
                    if players[k].x == i and players[k].y == j then
                        love.graphics.setColor(55, 55, 255)
                        love.graphics.print("P" .. k, i*TILESIZE, (j-2)*TILESIZE)
                        love.graphics.setColor(55, 55, 155)
                        if k == 1 then
                            love.graphics.print("WASD", (i-1)*TILESIZE + 1, (j-1)*TILESIZE)
                        elseif k == 2 then
                            love.graphics.print("ARROWS", (i-1)*TILESIZE - 1, (j-1)*TILESIZE)
                        end
                    end
                end
            end
        end
    end
    
    Draw.HUD()

    --Draw countdown
    if not game_begin then
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(countdown, map_x/2 * TILESIZE, map_y/2 * TILESIZE, 0, 2, 2)
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
        players[1].dir = 2
    elseif key == 'a' and players[1].dir ~= 3 then --move left
        players[1].dir = 1
    elseif key == 's' and players[1].dir ~= 2 then --move down
        players[1].dir = 4
    elseif key == 'd' and players[1].dir ~= 1 then --move right
        players[1].dir = 3
    end
    if     key == 'up'    and players[2].dir ~= 4 then --move up
        players[2].dir = 2
    elseif key == 'left'  and players[2].dir ~= 3 then --move left
        players[2].dir = 1
    elseif key == 'down'  and players[2].dir ~= 2 then --move down
        players[2].dir = 4
    elseif key == 'right' and players[2].dir ~= 1 then --move right
        players[2].dir = 3
    end

end

---------------
--STATE : PAUSE
---------------

function pause:draw()
    
    Draw.map()

    --Draw pause effect
    love.graphics.setColor(255, 255, 255,90)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

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

    --Draw gameover effect and text
    if winner == 0 then
        love.graphics.setColor(255, 0, 0,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print( "DRAW!", 20, 300, 0, 2, 2)
    else
        love.graphics.setColor(12, 69, 203,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(255, 255, 255)
        love.graphics.print( "WINNER IS PLAYER " .. winner, 20, 300, 0, 2, 2)
    end

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