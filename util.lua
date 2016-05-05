local Particle = require "particle"
local RGB      = require "rgb"
local FX       = require "fx"
local CPU      = require "cpu"
local Map      = require "map"
local UD       = require "utildraw"

--MODULE WITH LOGICAL, MATHEMATICAL AND USEFUL STUFF--

local util = {}


------------------
--UPDATE FUNCTIONS
------------------

--Update step and all players position
function util.tick(dt)
    local t

    --Update "real-time" stuff

    Particle.update(dt) --Particle effect
    glowEPS(dt)         --Make tiles glow
    
    --Update "timestep" stuff
    STEP = math.min(TIMESTEP, STEP + dt)
    if STEP >= TIMESTEP then    

        UpdateCPU()

        UpdateHuman()

        --Get players bodies
        Map.getRectangles()

        --Reset step counter
        STEP = 0
    end

end

--Updates cpu players position
function UpdateCPU()
    local x, y, dir

    for i, p in ipairs(P_T) do
        if not p.dead and p.cpu then
            dir = p.dir
            x = p.x
            y = p.y
            
            --Update map before moving
            MAP[y][x] = p.number


            --CPU LEVEL 1
            if p.level == 1 then

               dir = CPU.level_1(p)


            --CPU LEVEL 2
            elseif p.level == 2 then

               dir = CPU.level_2(p)

            --CPU LEVEL 3
            elseif p.level == 3 then

               dir = CPU.level_3(p)

            end


            --Get CPU next position
            if dir == 1 then
                x = math.max(1, x - 1)         --Left
            elseif dir == 2 then
                y = math.max(1, y-1)           --Up
            elseif dir == 3 then
                x = math.min(MAP_X, x+1)       --Right
            elseif dir == 4 then
                y = math.min(MAP_Y, y+1)       --Down
            end

            --Updates player direction
            p.dir = dir

            movePlayer(x,y,p)
        end
    end

end



--Updates non-cpu players positions
function UpdateHuman()
    local x, y, dir

    for i, p in ipairs(P_T) do
        if not p.dead and not p.cpu then
            dir = p.nextdir
            x = p.x
            y = p.y
            
            --Update map before moving
            MAP[y][x] = p.number

            --Move players 
            if dir == 1 then
                x = math.max(1, x - 1)         --Left
            elseif dir == 2 then
                y = math.max(1, y-1)           --Up
            elseif dir == 3 then
                x = math.min(MAP_X, x+1)       --Right
            elseif dir == 4 then
                y = math.min(MAP_Y, y+1)       --Down
            end

            --Updates player direction
            p.dir = dir

            movePlayer(x,y,p)
        end
    end

end

-----------------------
--USEFUL GAME FUNCTIONS
-----------------------

--Updates background position
function util.updateBG(dt)
    local t, max
    
    t = 60 --Speed to increase position
    max = 0

    BG_X = BG_X + dt * t

    --Cicles image to a suitable position
    if BG_X >= max then
        BG_X = -954
    end

end

function movePlayer(x,y,p)
    local c, x_,y_, color, tile, a, b

    --Remove player headbox
    HD_T["mapx"..p.x.."y"..p.y] = nil

    --Add glow effect for tile
    GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, p.b_color)


    for y_=p.y-1, p.y+1 do
        for x_=p.x-1,p.x+1 do
            if y_>=1 and y_<=MAP_Y and
               x_>=1 and x_<=MAP_X
            then
                if Map.isSurrounded(y_, x_) then
                    GLOW_T["mapx"..x_.."y"..y_] = nil
                end
            end
        end
    end


    --Creates a mini-explosion
    x_ = p.x*TILESIZE + BORDER - TILESIZE/2
    y_ = p.y*TILESIZE + BORDER - TILESIZE/2
    FX.particle_explosion(x_, y_, p.b_color, .5, 1, nil, nil, 1) --Create effect

    --Update player position
    p.x = x
    p.y = y


    CheckCollision(p)

    --Update map with player head
    MAP[p.y][p.x] = HEAD

    --Updates head box position
    if not p.dead then
        color = COLOR(p.h_color.r, p.h_color.g, p.h_color.b, p.h_color.a)
        HD_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)
    else
        color = COLOR(0,0,0)
        HD_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)
    end

    --Add glow effect for head
    GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)

end

--Checks collision between players and walls/another player
function CheckCollision(p)
    local color = COLOR(255,0,115)
    local x, y
    
    --Check collision with wall
    if MAP[p.y][p.x] >= 1 and MAP[p.y][p.x] <= HEAD then
        p.dead = true --Makes player dead
        
        x = p.x*TILESIZE + BORDER
        y = p.y*TILESIZE + BORDER
        FX.particle_explosion(x, y, color, nil, nil, nil, nil, nil, 2) --Create effect

    end

    --Check collision with other players
    for i, p2 in ipairs(P_T) do
        if p.number ~= p2.number then --Compare with different players
            if p.x == p2.x and p.y == p2.y then
                p.dead = true  --Makes inicial player dead
                p2.dead = true --Makes player2 dead

                x = p.x*TILESIZE + BORDER
                y = p.y*TILESIZE + BORDER
                FX.particle_explosion(x, y, color) --Create effect

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


--Handles winner of every game, and checks if match is over
function util.checkWinner()
    
    if winner ~= 0 then
        p = P_T[winner]
        --Increses player score
        p.score = p.score + 1

        if p.score >= GOAL then
            MATCH_BEGIN = false    --End of match, a player has reached target score
        end
    end

end

---------------------
--UTILITIES FUNCTIONS
---------------------

--Clears all elements in a table
function util.clearTable(T)
    
    if not T then return end --If table is empty
    --Clear T table
    for i, k in pairs (T) do
        T[i] = nil
    end

end

--Clear all buttons and textboxes tables
function util.clearAllTables(mode)
    
    util.clearTable(TB_T)

    util.clearTable(B_T)

    util.clearTable(BI_T)

    util.clearTable(TXT_T)

    util.clearTable(PB_T)

    util.clearTable(F_T)

    if mode ~= "inGame" then
        if mode ~= "gameover" then
            util.clearTable(I_T)
        end
        util.clearTable(PART_T)
        util.clearTable(GLOW_T)
        util.clearTable(HD_T)
        util.clearTable(FX_T)
        util.clearTable(BOX_T)
    end

end

--REDO THESE FUNCTIONS
--Glow effect
function glowEPS(dt)
    local t
    
    t = 3
    if GROWING then
        EPS = EPS + t*dt
        if EPS >= MAX_EPS then
            GROWING = false
        end
    else
        EPS = EPS - t*dt
        if EPS <= MIN_EPS then
            GROWING = true
        end
    end

end

--Glow effect for setup
function util.glowEPS_2(dt)
    local t
    
    t = 20
    if GROWING_2 then
        EPS_2 = EPS_2 + t*dt
        if EPS_2 >= MAX_EPS_2 then
            GROWING_2 = false
        end
    else
        EPS_2 = EPS_2 - t*dt
        if EPS_2 <= MIN_EPS_2 then
            GROWING_2 = true
        end
    end

end

--------------------
--GLOBAL FUNCTIONS
--------------------

--Exit program
function util.quit()

    love.event.quit()

end

function util.defaultKeyPressed(key)

    if key == 'q' then
        util.quit()
    elseif key == 'b' then
        UD.toggleDebug()
    elseif key == 'n' then
        UD.toggleDebugDraw()
    end

end
--------------------
--ZOEIRAZOEIRAZOEIRA 
--------------------

function util.zoera(text)

    for i, v in pairs(TXT_T) do
        v.text = text
    end

    for i, v in pairs(TB_T) do
        v.text = text
    end

    for i, v in pairs(B_T) do
        v.text = text
    end


    for i, v in pairs(PB_T) do
        v.text = text
    end

end

--Return functions
return util