--MODULE FOR COLOR AND STUFF--

local rgb = {}

--Color object
COLOR = Class{
    init = function(self, r, g, b, a)
        self.r     = r     --Red
        self.g     = g     --Green
        self.b     = b     --Blue
        if a then
        	self.a = a
        else
        	self.a = 255
        end
        
    end
}

--Return a random base color from the Color Table
function randomBaseColor()
    
    local color = math.random(#C_T)
    
    return C_T[color]

end

function rgb.randomColor()
    local offset = 40
    local value, newValue, valueRatio
    local color = randomBaseColor()

    value = (color.r + color.g + color.b)/3
    newValue = value + 2*math.random()*offset - offset
    valueRatio = newValue/value

    color.r = color.r * valueRatio
    color.g = color.g * valueRatio
    color.b = color.b * valueRatio 

    return color

end 

return rgb