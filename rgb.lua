--MODULE FOR COLOR AND STUFF--

local rgb = {}

--Color object
COLOR = Class{
    init = function(self, r, g, b)
        self.r     = r     --Red
        self.g     = g     --Green
        self.b     = b     --Blue
    end
}

return rgb