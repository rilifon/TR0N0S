--MODULE FOR EFFECTS AND STUFF--

local fx = {}

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

--Makes a smooth transition in object 0 from i to f in "duration" time
function fx.smoothTransition(o, i, f, duration)
    local diff = 0
    local a    = 0

    --Starts a timer that gradually increse
    Game_Timer.during(duration,

        --Gradually change actual color until target color
        function(dt)
        	local temp

            ratio = diff/duration
            diff = diff + dt

            temp = o
            o = math.abs(ratio * f + (1 - ratio) * i)
            a = a + (o - temp)
        end,
        
        function()

        --Adds the remaining to complete the transition
        o = o + (f - (i + a))
        
        end
    )

end

--Makes a smooth transition in object 'o' position
--from point (x0,y0) to point (xf,yf)
function fx.smoothMove(o, x0, y0, xf, yf, duration)
    local diff = 0
    local a_x  = 0       --Acumulation of x
    local a_y  = 0       --Acumulation of y

    --Starts a timer that gradually increse
    Game_Timer.during(duration,

        --Gradually change actual color until target color
        function(dt)
            local temp

            ratio = diff/duration
            diff = diff + dt

            temp = o.x
            o.x = math.abs(ratio * xf + (1 - ratio) * x0)
            a_x = a_x + (o.x - temp)

            temp = o.y
            o.y = math.abs(ratio * yf + (1 - ratio) * y0)
            a_y = a_y + (o.y - temp)


        end,
        
        function()

            --Adds the remaining to complete the transition
            o.x = o.x + (xf - (x0 + a_x))
            o.y = o.y + (yf - (y0 + a_y))

        end
    )

end

--Makes a smooth transition in color 'c'
--from COLOR(r0,g0,b0) to COLOR(rf,gf,bf)
function fx.smoothColor(c, color0, colorf, duration)
    local r0,g0,b0,rf,gf,bf
    local diff = 0
    local a_r = 0       --Acumulation of r
    local a_g = 0       --Acumulation of g
    local a_b = 0       --Acumulation of b


    r0 = color0.r
    g0 = color0.g
    b0 = color0.b
    rf = colorf.r
    gf = colorf.g
    bf = colorf.b

    --Starts a timer that gradually increse
    Game_Timer.during(duration,

        --Gradually change actual color until target color
        function(dt)
        	local temp

            ratio = diff/duration
            diff = diff + dt

            temp = c.r
            c.r = math.abs(ratio * rf + (1 - ratio) * r0)
            a_r = a_r + (c.r - temp)

			temp = c.g
            c.g = math.abs(ratio * gf + (1 - ratio) * g0)
            a_g = a_g + (c.g - temp)

            temp = c.b
            c.b = math.abs(ratio * bf + (1 - ratio) * b0)
            a_b = a_b + (c.b - temp)

        end,
        
        function()

            --Adds the remaining to complete the transition
            c.r = c.r + (rf - (r0 + a_r))
            c.g = c.g + (gf - (g0 + a_g))
            c.b = c.b + (bf - (b0 + a_b))

        end
    )

end

--Makes a smooth transition in object 'o' alpha
--from i to f
function fx.smoothAlpha(o, i, f, duration)
    local diff = 0
    local a_a  = 0       --Acumulation of a

    --Starts a timer that gradually increse
    o.h = Game_Timer.during(duration,

        --Gradually change actual color until target color
        function(dt)
        	local temp

            ratio = diff/duration
            diff = diff + dt

            temp = o.a
            o.a = math.abs(ratio * f + (1 - ratio) * i)
            a_a = a_a + (o.a - temp)
        end,
        
        function()

        --Adds the remaining to complete the transition
        o.a = o.a + (f - (i + a_a))
        
        end
    )

end



--Return functions
return fx
