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

--Return a random color based on a default color with some slight variation
function rgb.randomColor()
    local offset = 30
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

--Return a random complementary color based on a receiving color with some slight variation
function rgb.randomComplementaryColor(color)
    local Newcolor = COLOR((color.r+63+math.random(64))%255, (color.g+63+math.random(64))%255, (color.b+63+math.random(64))%255)

    return Newcolor

end

--Choses a random color from a table and transitions the map background to it 
function rgb.backgroundTransition()
    local r, g, b, ratio
    local duration = 5
    local diff = 0
    local ori_color = map_color 

    --Get a random different color for map background
    targetColor = MC_T[math.random(#MC_T)]
    while (targetColor == map_color) do
        targetColor = MC_T[math.random(#MC_T)]
    end

    --Starts a timer that gradually increse
    Game_Timer.during(duration,

        --Gradually change actual color until target color
        function(dt)
            ratio = diff/duration
            diff = diff + dt
            r = math.abs(ratio * targetColor.r + (1 - ratio) * ori_color.r)
            g = math.abs(ratio * targetColor.g + (1 - ratio) * ori_color.g)
            b = math.abs(ratio * targetColor.b + (1 - ratio) * ori_color.b)
            map_color = COLOR(r,g,b)
        end,

        --Calls parent function so that the transition is continuous
        function()
            map_color = targetColor
            rgb.backgroundTransition()
        end)

end 

return rgb