--MODULE FOR PARTICLES AND STUFF--

local particle = {}

--Color object
PARTICLE = Class{
    init = function(self, x, y, dir_x, dir_y, speed, color, decaying, r)
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

        self.r = r or 3 --Particle radius
    end
}

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

--Return functions
return particle