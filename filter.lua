--MODULE FOR SCREEN FILTER AND STUFF--

local filter = {}

--Filter object
FILTER = Class{
    init = function(self, color)
        self.color = {}
        self.color.r     = color.r         --Red
        self.color.g     = color.g         --Green
        self.color.b     = color.b         --Blue
        self.color.a     = color.a or 255  --Alpha
        
    end
}

return filter