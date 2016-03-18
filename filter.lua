--MODULE FOR SCREEN FILTER AND STUFF--

local filter = {}

--Filter object
FILTER = Class{
    init = function(self, color)
        self.color = {}
        self.color.r     = color.r     --Red
        self.color.g     = color.g     --Green
        self.color.b     = color.b     --Blue
        if color.a then
        	self.color.a = color.a
        else
        	self.color.a = 255
        end
        
    end
}

return filter