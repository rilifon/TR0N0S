--MODULE FOR EFFECTS AND STUFF--

local fx = {}

----------------
--EFFECT FUNCTIONS
----------------

--Creates a "glow" effect on position (x,y) with radius r and color c
function fx.glowCircle(x, y, r, c)
    
    FX_T["fx-glowx"..x.."y"..y] = CIRCLE(x, y, i, color, "fill")
    
end

--Creates a pulse effect on object o
function fx.pulse(o, sx, sy, d, m)
    local duration = d or .3 --Duration of effect
    local move = m or true --If it should also centralize while pulsing
    fx.smoothScale(o, sx, sy, duration/2, 'linear')
    
    if move then
        fx.smoothMove(o, o.x + o.w*(1-sx)/2, o.y + o.h*(1-sy)/2, duration/2, 'linear')
    end 

    Game_Timer.after(duration/2,
        function()
            local m = move

            if move then
                fx.smoothMove(o, o.x - o.w*(1-sx)/2, o.y - o.h*(1-sy)/2, duration/2, 'linear')
            end 

            fx.smoothScale(o, 1, 1, duration/2, 'linear')

        end
    )

end

--------------------
--PARTICLE FUNCTIONS
--------------------

--Creates a colored article explosion starting position (x,y)
function fx.particle_explosion(x, y, color, duration, max_part, speed, decaying)
    local duration = duration or 2    --Duration particles will stay on screen
    local max_part = max_part or 25   --Number of particles created in a explosion
    local speed    = speed    or 100  --Particles speed
    local decaying = decaying or .97  --Particles decaying speed
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

        part = PARTICLE(x, y, dir_x, dir_y, speed, p_color, decaying)
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


----------------------
--TRANSITION FUNCTIONS
----------------------

--Makes a smooth transition in object 0.i to f in "duration" time
function fx.smoothTransition(o, i, f, duration, func)

    --Starts a timer that gradually increse
    Game_Timer.tween(duration, o, {i = f}, func)

end

--Makes a smooth transition in object 0.i to f in "duration" time
function fx.smoothScale(o, sxf, syf, duration, func)

    --Starts a timer that gradually increse
    Game_Timer.tween(duration, o, {sx = sxf}, func)
    Game_Timer.tween(duration, o, {sy = syf}, func)

end


--Makes a smooth transition in object 'o' position
-- to point (xf,yf)
function fx.smoothMove(o, xf, yf, duration, func)

    --Starts a timer that gradually increase
    Game_Timer.tween(duration, o, {x = xf}, func)
    Game_Timer.tween(duration, o, {y = yf}, func)

end

--Makes a smooth transition in color 'c'
--to COLOR(rf,gf,bf)
function fx.smoothColor(c, color0, colorf, duration, func)
    local rf,gf,bf

    rf = colorf.r
    gf = colorf.g
    bf = colorf.b

    --Starts a timer that gradually increse
    Game_Timer.tween(duration, c, {r = rf, g = gf, b = bf}, func)

end

--Makes a smooth transition in object 'o' alpha
--to f
function fx.smoothAlpha(o, f, duration, func)

    --Starts a timer that gradually increase
    Game_Timer.tween(duration, o, {a = f}, func)

end



--Return functions
return fx
