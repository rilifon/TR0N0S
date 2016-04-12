--MODULE FOR COLOR AND STUFF--

local rgb = {}

--Color object
COLOR = Class{
    init = function(self, r, g, b, a, h)
        self.r     = r        --Red
        self.g     = g        --Green
        self.b     = b        --Blue
        self.a     = a or 255 --Alpha
        self.h     = h or nil --Timer handle applying to this color
        
    end
}

--Return a random base color from the Color Table
function randomBaseColor()
    local color = math.random(#C_T)
    
    return C_T[color]

end

--Return a random color based on a default color with some slight variation
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

--Return a random darker color based on a receiving color with some slight variation
function rgb.randomDarkColor(color)
    local Newcolor, rand

    --Generates a random number between 0.4 nd 0.7
    rand = math.random()*0.3 + 0.4
    Newcolor = COLOR(color.r*rand, color.g*rand, color.b*rand)

    return Newcolor

end

--Return functions
return rgb