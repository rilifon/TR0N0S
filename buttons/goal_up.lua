local FX  = require "fx"

local duration = .5  --Duration of particles
local max_part = 35  --Max number of particles
local speed    = 200 --Speed of particles
local decaying = .99 --Decaying speed of particles

--Function for goal_up button
function goal_up()
    local this = goal_up
    local x = 580
    local y = this.y
    local w = this.w
    local h = this.h
    local exp_color --Color of particle explosion
    local d = .3

    --Particles
    exp_color = COLOR(65,168,17)
    FX.particle_explosion(x+w/2, y+h/2, exp_color, duration, max_part, speed, decaying) --This button
    exp_color = COLOR(205,144,212)
    FX.particle_explosion(4*love.graphics.getWidth()/6 + 160, 200, exp_color, duration, 20, speed, .98) --Value

    --Shrink effect
    if not GOAL_UP_FLAG then
        FX.pulse(goal_up, -0.85, 0.85, d)
        GOAL_UP_FLAG = true
        Game_Timer.after(d, function() GOAL_UP_FLAG = false end)
    end

    GOAL = GOAL + 1
    I_T["goal_value"].text = GOAL

end

--Return function
return goal_up
