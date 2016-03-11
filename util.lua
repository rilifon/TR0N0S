--MODULE WITH USEFUL LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}

--Set game's global variables, random seed and window configuration
function util.configGame()
    
    --RANDOM SEED
    math.randomseed( os.time() )

    --GLOBAL VARIABLES

    DEBUG = false      --DEBUG mode status
    main_setup = false --Setup of whole game
    game_setup = false --Inicial setup for each game
    MAX_PLAYERS = 2    --Number of players playing
    MAX_COUNTDOWN = 3  --Countdown in the beggining of each match
    TIMESTEP = 0.04    --Time between each game step
    TILESIZE = 15      --Size of the game's tile
    BORDER = TILESIZE  --Border of the game map
    MARGIN = 12        --Size of margin for players' inicial position
    map = {}           --Game map
    map_x = 50         --Map x size (in tiles)
    map_y = 50         --Map y size (in tiles)

    --WINDOW CONFIG
    success = love.window.setMode(TILESIZE*map_x + 2*BORDER, TILESIZE*map_y + 2*BORDER, {borderless = not DEBUG})

    --FONT STUFF
    font_but_m = love.graphics.newFont( "assets/vanadine_bold.ttf", 30) --Font for buttons, medium size
    font_reg_m = love.graphics.newFont( "assets/FUTUVA.ttf", 30) --Font for regular text, medium size
    font_reg_s = love.graphics.newFont( "assets/FUTUVA.ttf", 16) --Font for regular text, small size
    love.graphics.setFont(font_reg_m)
end

 --Setup a new game
function util.setupGame()
    if not game_setup then
        countdown = MAX_COUNTDOWN
        Inicial_Timer = Timer.new()
        game_begin = false
        step = 0
        winner = 0
        
        resetMap()
        
        setupPlayers()

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

                                --Players go right the the start if they dont chose a direction
                                for k=1,MAX_PLAYERS do
                                    if players[k].dir     == 0 then players[k].dir     = 3 end
                                    if players[k].nextdir == 0 then players[k].nextdir = 3 end
                                end
                            end)
end


--Update step and all players position
function util.tick(dt)
    step = math.min(TIMESTEP, step + dt)
    if step >= TIMESTEP then    
        
        --Updates players positions
        for i=1,MAX_PLAYERS do
            if players[i].dead == false then
                local dir = players[i].nextdir
                local x = players[i].x
                local y = players[i].y
                
                --Draw player "trail" before moving
                map[x][y] = i

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

                --Updates player direction
                players[i].dir = dir
                
                --Update player position
                players[i].x = x
                players[i].y = y
                


            end
        end

        CheckCollision()

        --Reset step counter
        step = 0
    end
end

--Checks collision between players and walls/another player
function CheckCollision()
	
	for i=1,MAX_PLAYERS do
		
		if not players[i].dead then
			local p_x = players[i].x
			local p_y = players[i].y
			
			--Check collision with wall
			if map[p_x][p_y] ~= 0 then
				players[i].dead = true
			end

			--CHeck collision with other players
			for k=i+1,MAX_PLAYERS do
				if p_x == players[k].x and p_y == players[k].y then
					players[i].dead = true
					players[k].dead = true
				end
			end

		end

	end
end

--Count how many players are alive and declare a winner
function util.countPlayers()
	cont = 0
    winner = 0
    for i=1,MAX_PLAYERS do
        if players[i].dead == false then
            cont = cont+1
            winner = i
        end
    end
    return cont 
end

--Setup all players
function setupPlayers()
    
    local p_x = 1
    local p_y = 1
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
end

--Reset map, puttting 0 in all positions
function resetMap()
    for i=1,map_x do
        map[i] = {}
        for j=1,map_y do
            map[i][j] = 0
        end
    end
end
    


--Return functions
return util