local draw = {}

--Draws the game map
function draw.map()

    drawMap()

    drawHeads()

end

function drawMap()
    
    --Draw the tiles with the corresponding color
    for i=1,map_x do
        for j=1,map_y do

            if map[i][j] == 0 then
                love.graphics.setColor( 166, 216, 74 )
            elseif map[i][j] == 1 then
                love.graphics.setColor( 233, 131, 0  )
            elseif map[i][j] == 2 then
                love.graphics.setColor( 125, 0  , 99 )
            elseif map[i][j] == 3 then
                love.graphics.setColor( 237, 26 , 55 )
            elseif map[i][j] == 4 then
                love.graphics.setColor( 155, 155, 155)
            end
            love.graphics.rectangle("fill", i*TILESIZE, j*TILESIZE, TILESIZE, TILESIZE) --Draw tile            
        end
    end
end

function drawHeads()
    
    --Draw players heads
    for i=1,MAX_PLAYERS do
        
        --Checks if head is dead
        local dead = 1
        if players[i].dead then dead = 0 end

        --Draws heads
        if     i == 1 then
            love.graphics.setColor( 255*dead, 161*dead , 30*dead  )
        elseif i == 2 then
            love.graphics.setColor( 155*dead, 30*dead  , 129*dead )
        elseif i == 3 then
            love.graphics.setColor( 255*dead, 56*dead  , 85*dead  )
        elseif i == 4 then
            love.graphics.setColor( 185*dead, 185*dead , 185*dead )
        end

        love.graphics.rectangle("fill", players[i].x*TILESIZE, players[i].y*TILESIZE, TILESIZE, TILESIZE) --Draw tile     
    end
end

--Draw the game HUD
function draw.HUD()
    
    love.graphics.setColor(195, 129, 199)
    love.graphics.print("(q)uit        (p)ause", 0, (map_y+1)*TILESIZE)
    
    if DEBUG then
        love.graphics.print("DEBUG ON", 150, (map_y+1)*TILESIZE)
    end
end

--Draw gameover effect and text
function draw.gameover()
    
    --Case of a draw
    if winner == 0 then
        love.graphics.setColor(255, 0, 0,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
        
        love.graphics.setColor(255, 255, 255)
        love.graphics.print( "DRAW!", 20, 300, 0, 2, 2)
    
    --Case of a single winner
    else
        love.graphics.setColor(12, 69, 203,90)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(255, 255, 255)
        love.graphics.print( "WINNER IS PLAYER " .. winner, 20, 300, 0, 2, 2)
    end
end

--Draw pause effect and text
function draw.pause()
    
    love.graphics.setColor(255, 255, 255,90)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(255, 255, 255)
    love.graphics.print( "GAME PAUSED", 20, 300, 0, 2, 2)
end

--Draw players indicator
function draw.playerIndicator()

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

--Draw countdown in the beggining of every match
function draw.countdown()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(countdown, map_x/2 * TILESIZE, map_y/2 * TILESIZE, 0, 2, 2)
end


--Return functions
return draw
