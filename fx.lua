--MODULE FOR EFFECTS AND STUFF--

local fx = {}

------------------
--EFFECT FUNCTIONS
------------------

--Creates a "glow" effect on position (x,y) with radius r and color c
function fx.glowCircle(x, y, r, c)
    
    FX_T["fx-glowx"..x.."y"..y] = CIRCLE(x, y, i, color, "fill")
    
end

--Creates a pulse effect on object o
function fx.pulse(o, sx, sy, d, m)
    local duration = d or .2 --Duration of effect
    local move = m or true --If it should also centralize while pulsing
    local sxi, syi

    sxi = o.sx
    syi = o.sy

    fx.smoothScale(o, sx, sy, duration/2, 'linear')
    
    if move then
        fx.smoothMove(o, o.x + o.w*(sxi-sx)/2, o.y + o.h*(syi-sy)/2, duration/2, 'linear')
    end 

    Game_Timer.after(duration/2,
        function()
            local m = move

            if move then
                fx.smoothMove(o, o.x - o.w*(sxi-sx)/2, o.y - o.h*(syi-sy)/2, duration/2, 'linear')
            end 

            fx.smoothScale(o, sxi, syi, duration/2, 'linear')

        end
    )

end

function fx.pulseLoop(o, sx, sy, d, m)
    
    fx.pulse(o, sx, sy, d, m)
    
    Game_Timer.after(d, 
        function()
            fx.pulseLoop(o, sx, sy, d, m)
        end
    )

end

--Creates an entrance effect for player p in the beguining of the game
function fx.playerEntrance(p)
    local color, d, box, xf, yf
    local dir, x, y, w, h

    --HUMAN PLAYER
    if not p.cpu then
        --Get random position outside the game window to spawn player box
        dir = math.random(4)
        if     dir == 1 then
            x = -2*TILESIZE
            y = math.random(love.graphics.getHeight())
        elseif dir == 2 then
            x = math.random(love.graphics.getWidth())
            y = -2*TILESIZE
        elseif dir == 3 then
            x = love.graphics.getWidth() + 2*TILESIZE
            y = math.random(love.graphics.getHeight())
        elseif dir == 4 then
            x = math.random(love.graphics.getWidth())
            y = love.graphics.getHeight() + 2*TILESIZE
        end

        w = 10*TILESIZE
        h = 10*TILESIZE
        color = COLOR(p.h_color.r, p.h_color.g, p.h_color.b, p.h_color.a)
        
        box = BOX(x, y, w, h, color)
        PBOX_T["P"..p.number.."effect"] = box
        box = PBOX_T["P"..p.number.."effect"]

        xf = BORDER + (p.x - 1)*TILESIZE
        yf = BORDER + (p.y - 1)*TILESIZE
        d = 1.2
        --Move player
        fx.smoothMove(box, xf, yf, d, 'linear')
        --Scale player
        fx.smoothDimension(box, TILESIZE, TILESIZE, d, 'linear')
        --Spin player
        fx.smoothRotation(box, 20, d, 'linear')
        
        --Set players to be ready for game
        Game_Timer.after(d, 
            function ()
                
                PBOX_T["P"..p.number.."effect"] = nil

                --Update map with players head
                tile = TILE(p.x, p.y, color) --Creates a tile
                HD_T["mapx"..p.x.."y"..p.y] = tile

                --Add glow effect for head
                GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)

                fx.shake(.3)

            end
        )
    --CPU PLAYER
    else

        color = COLOR(p.h_color.r, p.h_color.g, p.h_color.b, 0)

        --Update map with players head
        tile = TILE(p.x, p.y, color) --Creates a tile
        HD_T["mapx"..p.x.."y"..p.y] = tile
        tile = HD_T["mapx"..p.x.."y"..p.y]

        --Add glow effect for head
        GLOW_T["mapx"..p.x.."y"..p.y] = TILE(p.x, p.y, color)

        d = 1
        --Creates fade-in effect on players
        fx.smoothAlpha(HD_T["mapx"..p.x.."y"..p.y].color, 255, d, 'linear')
        fx.smoothAlpha(GLOW_T["mapx"..p.x.."y"..p.y].color, 255, d, 'linear')

    end

end

--------------------
--PARTICLE FUNCTIONS
--------------------

--Creates a colored article explosion starting position (x,y)
function fx.particle_explosion(x, y, color, duration, max_part, speed, decaying, radius)
    local duration = duration or 2    --Duration particles will stay on screen
    local max_part = max_part or 25   --Number of particles created in a explosion
    local speed    = speed    or 100  --Particles speed
    local decaying = decaying or .97  --Particles decaying speed
    local radius   = radius or 3
    local p_color, part, rand, max 
    local dir_x, dir_y --Direction for particle
    local id = math.random() --Creates an id for this explosion

    --Creates all particles of explosion
    for i=1, max_part do
        
        --Randomize direction for each particle
        if math.random() < 0.5 then dir_x = 1 else dir_x = -1 end
        if math.random() < 0.5 then dir_y = 1 else dir_y = -1 end
        dir_x = math.random()*dir_x
        dir_y = math.random()*dir_y
        
        --Randomize lightning for each particle
        max = 70 --Maximum variation of lightning
        rand = math.random()*max*2 - max --Varies between -max and max
        p_color  = COLOR(color.r+rand, color.g+rand, color.b+rand)

        part = PARTICLE(x, y, dir_x, dir_y, speed, p_color, decaying, radius)
        PART_T["px"..x.."y"..y.."i"..i.."id"..id] = part
    end

    --Timer for removing particles
    Game_Timer.after(duration, 
        function()
            
            for i=1, max_part do
                PART_T["px"..x.."y"..y.."i"..i.."id"..id] = nil
            end

        end
    )
end

------------------
--CAMERA FUNCTIONS
------------------

--Shake the camera for d seconds
function fx.shake(d)
    local orig_x, orig_y

    orig_x = CAM.x
    orig_y = CAM.y

    Game_Timer.during(d, 
        function()
            CAM.x = orig_x + math.random(-2,2)
            CAM.y = orig_y + math.random(-2,2)
        end,
        function()
            -- reset camera position
            CAM.x = orig_x
            CAM.y = orig_y
        end
    )
end

----------------------
--TRANSITION FUNCTIONS
----------------------

--Makes a smooth transition in object o.i to f in "duration" time
function fx.smoothTransition(o, i, f, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {i = f}, func)

end

--Makes a smooth transition in object scale to sxf and syf in "duration" time
function fx.smoothScale(o, sxf, syf, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {sx = sxf}, func)
    Game_Timer.tween(duration, o, {sy = syf}, func)

end

--Makes a smooth transition in object width and height to wf and hf in "duration" time
function fx.smoothDimension(o, wf, hf, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {w = wf}, func)
    Game_Timer.tween(duration, o, {h = hf}, func)

end


--Makes a smooth transition in object with and height to wf and hf in "duration" time
function fx.smoothRotation(o, rf, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {r = rf}, func)

end

--Makes a smooth transition in object 'o' position
-- to point (xf,yf)
function fx.smoothMove(o, xf, yf, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {x = xf}, func)
    Game_Timer.tween(duration, o, {y = yf}, func)

end

--Makes a smooth transition in color 'c'
--to COLOR(rf,gf,bf)
function fx.smoothColor(c, colorf, duration, func)
    local rf,gf,bf,af

    rf = colorf.r
    gf = colorf.g
    bf = colorf.b
    af = colorf.a

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, c, {r = rf, g = gf, b = bf, a = af}, func)

end

--Makes a smooth transition in object 'o' alpha
--to f
function fx.smoothAlpha(o, f, duration, func)

    --Starts a timer that gradually increases
    Game_Timer.tween(duration, o, {a = f}, func)

end

--Return functions
return fx
