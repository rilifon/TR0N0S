local draw = {}

function draw.map()

    for i=1,map_x do
        for j=1,map_y do
            
            --Check if its head and if dead
            local head = 0
            local is_dead = 1
            for k=1,MAX_PLAYERS do
                if i == players[k].x and j == players[k].y then
                    head = 40
                    
                    p = k

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
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE) --Draw tile
            
            
        end
    end
end

function draw.HUD()
    love.graphics.setColor(195, 129, 199)
    love.graphics.print("(q)uit        (p)ause", 0, (map_y+1)*TILESIZE)
    if DEBUG then
        love.graphics.print("DEBUG ON", 150, (map_y+1)*TILESIZE)
    end
end

return draw
