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

return rgb