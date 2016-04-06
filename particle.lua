--MODULE FOR PARTICLES AND STUFF--

local particle = {}

--Color object
PARTICLE = Class{
    init = function(self, x, y, dir_x, dir_y, speed, color, decaying)
        self.x = x                   --Particle X position
        self.y = y                   --Particle Y position
        self.dir_x = dir_x           --X direction of particle
        self.dir_y = dir_y           --Y direction of particle
        self.speed = speed           --Particle speed
        self.color = {}
        self.color.r  = color.r         --Red
        self.color.g  = color.g         --Green
        self.color.b  = color.b         --Blue
        self.color.a  = color.a or 255  --Alpha
        self.decaying = decaying        --Decaying speed of particle
    end
}

--Creates a colored article explosion starting position (x,y)
function particle.explosion(x, y, color, duration, max_part, speed, decaying)
    local duration = duration or 2    --Duration particles will stay on screen
    local max_part = max_part or 25   --Number of particles created in a explosion
    local speed    = speed    or 100  --Particles speed
    local decaying = decaying or .95  --Particles decaying speed
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

--Updates all particles positions
function particle.update(dt)
    
    for i, p in pairs(PART_T) do
        --Moves particles
        p.x = p.x + p.dir_x * p.speed * dt
        p.y = p.y + p.dir_y * p.speed * dt
        --Fade-out effect
        p.color.a = p.color.a * p.decaying
    end

end

return particle