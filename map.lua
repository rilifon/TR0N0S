local FX   = require "fx" 
local UD   = require "utildraw"

--MODULE FOR MAP STUFF--

local mp = {}

-----------------
--RESET FUNCTIONS
-----------------

--Reset map, puttting 0 in all positions
function mp.reset()
    
    --Reset all map positions to 0 and create a tile
    for i=1,MAP_Y do
        for j=1,MAP_X do
            MAP[i][j] = 0 --Reset map
        end
    end
end

--Reset aux_map, puttting 0 in all positions
function resetAuxMap()
    
    --Reset all map positions to 0 and create a tile
    for i=1,MAP_Y do
        for j=1,MAP_X do
            AUX_MAP[i][j] = 0 --Reset map
        end
    end

end

--------------------
--UTILITY FUNCTIONS
--------------------

--Checks if position (x,y) is inside map
function mp.validPosition(x, y)
    
    if x < 1 or x > MAP_X or y < 1 or y > MAP_Y then
        return false
    end

    return true 
end

--Returns next position starting in (x,y) and going direction dir
function mp.nextPosition(x, y, dir)

    if dir == 1 then     --Left
        x = x - 1
    elseif dir == 2 then --Up
        y = y - 1      
    elseif dir == 3 then --Right
        x = x + 1
    elseif dir == 4 then --Down
        y = y + 1
    end

    return x, y
end

--Checks if tile (i,j) is completely surrounded by other tiles
function mp.isSurrounded(i, j)

    for a=i-1, i+1 do
        for b=j-1,j+1 do
            
            --Get middle cases
            if a>=1 and a<=MAP_Y and
               b>=1 and b<=MAP_X
            then
                if MAP[a][b] == 0 then
                    return false
                end
            end

            --Edge cases
            if a == 1 or a == MAP_Y or b == 1 or b == MAP_X then
                return false
            end 

        end
    end

    return true
end


----------------
--COLOR FUNCTION
----------------

--Choses a random color from a table and transitions the map background to it 
function mp.backgroundTransition()
    local duration = 5
    local targetColor, ori_color

    ori_color = COLOR(MAP_COLOR.r, MAP_COLOR.g, MAP_COLOR.b)

    --Fixing imprecisions
    ori_color.r = math.floor(ori_color.r + .5)
    ori_color.g = math.floor(ori_color.g + .5)
    ori_color.b = math.floor(ori_color.b + .5)

    --Get a random different color for map background
    targetColor = MC_T[math.random(#MC_T)]

    while ((targetColor.r == ori_color.r) and
           (targetColor.g == ori_color.g) and
           (targetColor.b == ori_color.b)) do

        targetColor = MC_T[math.random(#MC_T)]
    end

    FX.smoothColor(MAP_COLOR, targetColor, duration, 'linear')

    --Starts a timer that gradually increse
    Color_Timer.after(duration + .3,
        
        --Calls parent function so that the transition is continuous
        function()

            mp.backgroundTransition()

        end
    )

end

--------------------
--ALGORITHM FUNCTION
--------------------

function mp.getRectangles()
    local current, stop, box, db, color, p_c
    local x, y, i, j
    local w, h, k, l

    --Clear all existing rectangles
    if not BOX_T then return end --If table is empty
    for i, k in pairs (BOX_T) do --Clear table
        BOX_T[i] = nil
    end

    --Clear auxiliar map
    resetAuxMap()

    --Sweep over auxiliar map
    for i=1,MAP_Y do
        for j=1,MAP_X do
            if AUX_MAP[i][j] == 0 then
                current = MAP[i][j] --Current player
                AUX_MAP[i][j] = 1

                if current ~= 0 and current ~= HEAD then --Colored tile

                    --Find biggest width
                    w = 1
                    k = j + 1
                    while MAP[i][k] == current and k <= MAP_X and AUX_MAP[i][k] == 0 do
                        AUX_MAP[i][k] = 1
                        w = w + 1
                        k = k + 1
                    end
                    
                    --Find biggest height for correspondent width
                    stop = false
                    h = 1
                    l = i + 1
                    while stop == false and l <= MAP_Y do
                        h = h+1
                        for k=j,j+w-1 do
                            if MAP[l][k] ~= current or AUX_MAP[l][k] == 1  then
                                if stop == false then
                                    h = h - 1
                                end
                                stop = true
                            end
                        end
                        l = l + 1
                    end

                    --Mark as positions visited
                    for l=i,i+h-1 do
                        for k=j,j+w-1 do
                            AUX_MAP[l][k] = 1
                        end
                    end

                    --Create rectangle
                    x = BORDER + (j-1)*TILESIZE
                    y = BORDER + (i-1)*TILESIZE
                    
                    if DEBUG_DRAW then
                        db = (10*x + 15*y)%130
                        color = COLOR(0.9*db, 1.2*db, 1.5*db)
                    else
                        p_c = P_T[current].b_color
                        color = COLOR(p_c.r, p_c.g, p_c.b, p_c.a)
                    end

                    box = BOX(x, y, w*TILESIZE, h*TILESIZE, color)
                    BOX_T["x"..j.."y"..i] = box
                end
            end
        end
    end

end

--------------------
--COUNTDOWN FUNCTION
--------------------

--Start the countdown to start a game
function mp.startCountdown()
    local cd = countdown
    local t, rand
    
    time = 0
    Game_Timer.during(MAX_COUNTDOWN, 
        --Decreases countdown
        function(dt)
            
            t = time+dt
            cd = cd - t
            countdown = math.floor(cd)+1

        end,

        --After countdown, start game and fixes players positions
        function()

            UD.removePlayerIndicator()

            GAME_BEGIN = true
            --Players go at a random direction at the start if they dont chose any
            for i, p in ipairs(P_T) do
                rand = math.random(4)
                if p.dir     == nil then p.dir     = rand end
                if p.nextdir == nil then p.nextdir = rand end
            end

        end
    )

end



--Return functions
return mp