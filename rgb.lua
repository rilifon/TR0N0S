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

--Return a random base color id not used from the Color Table
function rgb.randomBaseColor()
    local color_id
    
    color_id = math.random(#C_T)
    
    while C_MT[color_id] == 1 do
        color_id = math.random(#C_T)
    end

    C_MT[color_id] = 1

    return color_id

end

--Return a random color based on a default color_id with some slight variation
function rgb.randomColor(color_id)
    local color

    color = C_T[color_id]

    color.r = color.r
    color.g = color.g
    color.b = color.b

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