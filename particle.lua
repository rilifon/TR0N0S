--MODULE FOR PARTICLES AND STUFF--

local particle = {}

--Color object
PARTICLE = Class{
    init = function(self, x, y, dir_x, dir_y, speed, color)
        self.x = x                   --Particle X position
        self.y = y                   --Particle Y position
        self.dir_x = dir_x           --X direction of particle
        self.dir_y = dir_y           --Y direction of particle
        self.speed = speed           --Particle speed
        self.color = {}
        self.color.r     = color.r   --Red
        self.color.g     = color.g   --Green
        self.color.b     = color.b   --Blue
        if color.a then
        	self.color.a = color.a   --Alpha
        else
        	self.color.a = 255
        end
        
    end
}

--Creates a p colored article explosion starting position (x,y)
function particle.explosion(x, y, color)
    local duration = 1    --Duration particles will stay on screen
    local max_part = 30   --Number of particles created in a explosion
    local speed    = 50   --Particles speed
    local part
    local signal_x, signal_y --signal (positive or negative) for dir_x and dir_y
    --Creates all particles of explosion
    for i=1, max_part do
        if math.random() < 0.5 then signal_x = 1 else signal_x = -1 end
        if math.random() < 0.5 then signal_y = 1 else signal_y = -1 end
        --Creates a random particle
        part = PARTICLE(x + math.random(), y + math.random(), math.random()*signal_x, math.random()*signal_y, speed, color)

        PART_T["px"..x.."y"..y.."i"..i] = part
    end
    --Timer for removing particles
    Game_Timer.after(duration, 
        function()
            
            for i=1, max_part do
                PART_T["px"..x.."y"..y.."i"..i] = nil
            end

        end)

end

function particle.update(dt)
    
    for i, p in pairs(PART_T) do
        p.x = p.x + p.dir_x * p.speed * dt
        p.y = p.y + p.dir_y * p.speed * dt
    end

end

return particle