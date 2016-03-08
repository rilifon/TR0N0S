Gamestate = require "hump.gamestate"

--GAMESTATES
local menu = {}
local game = {}
local pause = {}
local gameover = {}

function love.load()
    MAX_PLAYERS = 2
    DEBUG = true
    game_started = false
    Gamestate.registerEvents()
    Gamestate.switch(game)
end

---------------
--STATE : GAME
---------------

function game:enter()
    --Setup game
    if not game_started then
        game_begin = false
        step = 0
        TIMESTEP = 0.04
        TILESIZE = 15
        BORDER = TILESIZE
        map_x = 50
        map_y = 50
        success = love.window.setMode(TILESIZE*map_x + 2*BORDER, TILESIZE*map_y + 2*BORDER, {borderless = true})
        map = {}
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
                p_x = math.random(map_x)
                p_y = math.random(map_y)
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

            players[i].dir = 4 --All players start with the down direction

            players[i].dead = false

            map[players[i].x][players[i].y] = i --Paint the inicial position
        end

        game_started = true
    end
end

function game:update(dt)
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
                        x = math.max(1, x - 1) --left
                    elseif dir == 2 then
                        y = math.max(1, y-1) --up
                    elseif dir == 3 then
                        x = math.min(map_x, x+1) --right
                    elseif dir == 4 then
                        y = math.min(map_y, y+1) -- down
                    end
                    --Update player position
                    players[i].x = x
                    players[i].y = y
                    --Check collision
                    if map[x][y] ~= 0 then
                        players[i].dead = true
                    --Paint map
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
    
   --Draw map
    for i=1,map_x do
        for j=1,map_y do
            
            --Check if its head and if dead
            local head = 0
            local is_dead = 1
            for k=1,MAX_PLAYERS do
                if i == players[k].x and j == players[k].y then
                    head = 40
                    if players[k].dead == true then is_dead = 0 end
                end
            end


            if map[i][j] == 0 then
                love.graphics.setColor( 166, 216, 74)
            elseif map[i][j] == 1 then
                love.graphics.setColor( (233+head)*is_dead, (131+head)*is_dead,  (0+head)*is_dead)
            elseif map[i][j] == 2 then
                love.graphics.setColor( (125+head)*is_dead, (0+2*head)*is_dead,  (99+head)*is_dead)
            elseif map[i][j] == 3 then
                love.graphics.setColor(  237*is_dead,       (26+2*head)*is_dead, (55+2*head)*is_dead)
            elseif map[i][j] == 4 then
                love.graphics.setColor( (155+head)*is_dead, (155+head)*is_dead,  (155+head)*is_dead)
            end
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE)
        end
    end
end

function game:keypressed(key)

    --BEGIN GAME
    if key and not game_begin then
        game_begin = true
    end

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
    elseif key == 'p' then
        Gamestate.switch(pause)
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
    
    --Draw map
    for i=1,map_x do
        for j=1,map_y do
            
            --Check if its head and if dead
            local head = 0
            local is_dead = 1
            for k=1,MAX_PLAYERS do
                if i == players[k].x and j == players[k].y then
                    head = 40
                    if players[k].dead == true then is_dead = 0 end
                end
            end


            if map[i][j] == 0 then
                love.graphics.setColor( 166, 216, 74)
            elseif map[i][j] == 1 then
                love.graphics.setColor( (233+head)*is_dead, (131+head)*is_dead,  (0+head)*is_dead)
            elseif map[i][j] == 2 then
                love.graphics.setColor( (125+head)*is_dead, (0+2*head)*is_dead,  (99+head)*is_dead)
            elseif map[i][j] == 3 then
                love.graphics.setColor(  237*is_dead,       (26+2*head)*is_dead, (55+2*head)*is_dead)
            elseif map[i][j] == 4 then
                love.graphics.setColor( (155+head)*is_dead, (155+head)*is_dead,  (155+head)*is_dead)
            end
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE)
        end
    end

    --Draw pause effect
    love.graphics.setColor(255, 255, 255,90)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
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
    
    --Draw map
    for i=1,map_x do
        for j=1,map_y do
            
            --Check if its head and if dead
            local head = 0
            local is_dead = 1
            for k=1,MAX_PLAYERS do
                if i == players[k].x and j == players[k].y then
                    head = 40
                    if players[k].dead == true then is_dead = 0 end
                end
            end


            if map[i][j] == 0 then
                love.graphics.setColor( 166, 216, 74)
            elseif map[i][j] == 1 then
                love.graphics.setColor( (233+head)*is_dead, (131+head)*is_dead,  (0+head)*is_dead)
            elseif map[i][j] == 2 then
                love.graphics.setColor( (125+head)*is_dead, (0+2*head)*is_dead,  (99+head)*is_dead)
            elseif map[i][j] == 3 then
                love.graphics.setColor(  237*is_dead,       (26+2*head)*is_dead, (55+2*head)*is_dead)
            elseif map[i][j] == 4 then
                love.graphics.setColor( (155+head)*is_dead, (155+head)*is_dead,  (155+head)*is_dead)
            end
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE)
        end
    end

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
end

function gameover:keypressed(key)

    --CHANGE STATES
    if key == 'q' then
        love.event.quit()
    elseif key == 'r' then
        game_started = false
        Gamestate.switch(game)
    end

end