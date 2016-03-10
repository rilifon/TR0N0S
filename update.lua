local update = {}

--Update step and all players position
function update.tick(dt)
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


--Return functions
return update