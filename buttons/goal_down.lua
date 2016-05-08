local FX  = require "fx"

local duration = .5  --Duration of particles
local max_part = 35  --Max number of particles
local speed    = 200 --Speed of particles
local decaying = .99 --Decaying speed of particles

--Function for goal_down button
function goal_down()
    local this = goal_down
    local x = 668
    local y = this.y
    local w = this.w
    local h = this.h
    local exp_color --Color of particle explosion
    local d = .3

    if GOAL > 1 then
        
        --Particles
        exp_color = COLOR(217,9,18) 
        FX.particle_explosion(x-w/2, y+h/2, exp_color, duration, max_part, speed, decaying) --Button explosion
        exp_color = COLOR(205,144,212)
        FX.particle_explosion(4*love.graphics.getWidth()/6 + 160, 200, exp_color, duration, 20, speed, .98) --Value

        --Shrink effect
        if not GOAL_DOWN_FLAG then
            FX.pulse(goal_down, 0.85, 0.85, d)
            GOAL_DOWN_FLAG = true
            Game_Timer.after(d, function() GOAL_DOWN_FLAG = false end)
        end

        GOAL = GOAL - 1
        I_T["goal_value"].text = GOAL

    end
end
    

--Return function
return goal_down
