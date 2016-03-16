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
    MAX_PLAYERS = 7    --Max number of players in a game
    N_PLAYERS = 2      --Number of players playing
    WASD_PLAYER = 1    --Player using wasd keys
    ARROWS_PLAYER = 2  --Player using arrow keys
    MAX_COUNTDOWN = 3  --Countdown in the beggining of each match
    TIMESTEP = 0.06    --Time between each game step
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

                                --Players go at a random direction at the start if they dont chose any
                                for i, p in ipairs(P_T) do
                                    local rand = math.random(4)
                                    if p.dir     == nil then p.dir     = rand end
                                    if p.nextdir == nil then p.nextdir = rand end
                                end
                            end)
end


--Update step and all players position
function util.tick(dt)
    step = math.min(TIMESTEP, step + dt)
    if step >= TIMESTEP then    
        
        UpdateCPU()

        UpdateHuman()

        CheckCollision()

        --Reset step counter
        step = 0
    end
end

--Updates cpu players position
function UpdateCPU()
    for i, p in ipairs(P_T) do
        if not p.dead and p.cpu then
            local dir = p.dir
            local x = p.x
            local y = p.y
            
            --Draw player "trail" before moving
            map[x][y] = p.number


            --CPU LEVEL 1
            --Has 80% of going the same direction, and 20% of "turning" left or right
            if p.level == 1 then

                --Chooses a random different valid (not reverse) direction
                if math.random() <= .2 then
                    --"Turn right"    
                    if math.random() <= .5 then
                        dir = dir%4 + 1
                    --"Turn left"
                    else
                        dir = (dir+2)%4 + 1
                    end
                end

            end


            --Move CPU
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
            p.dir = dir
            
            --Update player position
            p.x = x
            p.y = y

        end

    end
end

--Updates non-cpu players positions
function UpdateHuman()
    
    for i, p in ipairs(P_T) do
        if not p.dead and not p.cpu then
            local dir = p.nextdir
            local x = p.x
            local y = p.y
            
            --Draw player "trail" before moving
            map[x][y] = p.number

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
            p.dir = dir
            
            --Update player position
            p.x = x
            p.y = y
            
        end
    end
end

--Update players textbox on setup
function util.updatePlayersBox()
    local font = font_but_m
    local color_b = COLOR(133, 121, 0)
    local color_t = COLOR(0, 0, 0)    

    --Clear PTB_T table
    for k in pairs (PTB_T) do
        PTB_T[k] = nil
    end

    for i, p in ipairs(P_T) do
        local cputext, controltext
        if p.cpu then
            cputext = "CPU"
            controltext = "Level " .. p.level
        else
            cputext = "HUMAN"
            controltext = p.control
        end

        local ptb = TB(40, 200 + 45*i, 500, 40, "PLAYER " .. i .. " " .. cputext .. " (" .. controltext .. ")", font, color_b, color_t)
        table.insert(PTB_T, ptb)
    end
end


--Checks collision between players and walls/another player
function CheckCollision()
	
	for i, p1 in ipairs(P_T) do
		
		if not p1.dead then
			
			--Check collision with wall
			if map[p1.x][p1.y] ~= 0 then
				p1.dead = true
			end

			--Check collision with other players
			for j=i+1, #P_T do
				if p1.x == P_T[j].x and p1.y == P_T[j].y then
					p1.dead = true
					P_T[j].dead = true
				end
			end

		end

	end
end

--Count how many players are alive and declare a winner
function util.countPlayers()
	cont = 0
    winner = 0
    for i, p in ipairs(P_T) do
        if p.dead == false then
            cont = cont+1
            winner = p.number
        end
    end
    return cont 
end

--Setup all players
function setupPlayers()
    
    local p_x
    local p_y
    players = {}
    
    for i, p in ipairs(P_T) do

        --Get random positions for all players
        local is_rand = false
        while is_rand == false do
            p_x = math.random(map_x-2*MARGIN)+MARGIN
            p_y = math.random(map_y-2*MARGIN)+MARGIN
            is_rand = true
            --Iterate in all other players and checks for a valid position
            for j=1,i-1 do
                if(p_x == P_T[j].x and p_y == P_T[j].y) then
                    is_rand = false
                end
            end
        end

        p.x = p_x  --Player x position
        p.y = p_y  --Player y position

        p.dir     = nil --Player current direction
        p.nextdir = nil --Player next direction

        p.dead = false

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