local Map = require "map"

--MODULE FOR CPU STUFF--

local cpu = {}

--------------------
--CPU'S AI FUNCTIONS
--------------------

--CPU LEVEL 1 - "L4-M0"
--Has 80% of going the same direction, and 20% of "turning" left or right
function cpu.level_1(p)
    local dir = p.dir

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

    return dir
end

--CPU LEVEL 2 - "TIMMY-2000"
--If it would reach an obstacle, turns direction
function cpu.level_2(p)
    local dir = p.dir
    local next_x, next_y --Position that the CPU will go if move forward
    local left_x, left_y --Position that the CPU will go if turn left
    local right_x, right_y --Position that the CPU will go if turn right

            
    next_x, next_y = Map.nextPosition(p.x, p.y, dir)
    left_x, left_y = Map.nextPosition(p.x, p.y, (dir + 2)%4 + 1)
    right_x, right_y = Map.nextPosition(p.x, p.y, dir%4 + 1)

    --Found obstacle
    if  not Map.validPosition(next_x, next_y) or MAP[next_y][next_x] ~= 0 then
        --Randomly tries to go right or left when reaching
        if math.random() < 0.5 then
            if  Map.validPosition(left_x, left_y) and MAP[left_y][left_x] == 0 then
                dir = (dir + 2)%4 + 1 --turn left
            else
                dir = dir%4 + 1       --turn right
            end
        else
            if  Map.validPosition(right_x, right_y) and MAP[right_y][right_x] == 0 then
                dir = dir%4 + 1       --turn right
            else
                dir = (dir + 2)%4 + 1 --turn left
            end
        end
    end

    return dir
end

--CPU LEVEL 3 - "R0B1N"
--Goes around everything
function cpu.level_3(p)
    local dir = p.dir
    local next_x, next_y   --Position that the CPU will go if move forward
    local left_x, left_y   --Position that the CPU will go if turn left
    local right_x, right_y --Position that the CPU will go if turn right
    local side = p.side    --Side CPU is going around

    next_x, next_y   = Map.nextPosition(p.x, p.y, dir)
    left_x, left_y   = Map.nextPosition(p.x, p.y, (dir + 2)%4 + 1)
    right_x, right_y = Map.nextPosition(p.x, p.y, dir%4 + 1)

    if side == "left" then

        --Can go left?
        if Map.validPosition(left_x, left_y) and MAP[left_y][left_x] == 0 then
            dir = (dir + 2)%4 + 1 --turn left
        --Can't go forward?
        elseif not Map.validPosition(next_x, next_y) or MAP[next_y][next_x] ~= 0 then
            dir = dir%4 + 1       --turn right
        end

    elseif side == "right" then

        --Can go right?
        if Map.validPosition(right_x, right_y) and MAP[right_y][right_x] == 0 then
            dir = dir%4 + 1       --turn right
        --Can't go forward?
        elseif not Map.validPosition(next_x, next_y) or MAP[next_y][next_x] ~= 0 then
            dir = (dir + 2)%4 + 1 --turn left
        end

    elseif side == nil then

        --Found obstacle
        if  not Map.validPosition(next_x, next_y) or MAP[next_y][next_x] ~= 0 then
            if math.random() < 0.5 then
                if  Map.validPosition(left_x, left_y) and MAP[left_y][left_x] == 0 then
                    dir = (dir + 2)%4 + 1 --turn left
                    p.side = "right"
                else
                    dir = dir%4 + 1       --turn right
                    p.side = "left"
                end
            else
                if  Map.validPosition(right_x, right_y) and MAP[right_y][right_x] == 0 then
                    dir = dir%4 + 1       --turn right
                    p.side = "left"
                else
                    dir = (dir + 2)%4 + 1 --turn left
                    p.side = "right"
                end
            end
        end
    end

    return dir
end

--Return functions
return cpu