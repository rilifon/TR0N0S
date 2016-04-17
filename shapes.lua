--MODULE FOR SHAPES AND STUFF--

local shape = {}

--Box object
BOX = Class{
    init = function(self, x, y, w, h, color)
        self.x     = x     --x position
        self.y     = y     --y position
        self.w     = w     --width
        self.h     = h     --height
        
        --Color of box
        self.color = {}
        self.color.r = color.r
        self.color.g = color.g
        self.color.b = color.b
        self.color.a = color.a or 255
    end
}

--MapTile object
TILE = Class{
    init = function(self, x, y, color)
        self.x     = x     --x position
        self.y     = y     --y position
        self.w     = w     --width
        self.h     = h     --height
        
        --Color of tile

        self.color = {}
        self.color.r = color.r
        self.color.g = color.g
        self.color.b = color.b
        self.color.a = color.a or 255
    end
}

--Color object
CIRCLE = Class{
    init = function(self, x, y, r, color, mode)
        self.x       = x        --X position
        self.y       = y        --Y position
        self.r       = r        --Radius

        self.color = {}
        self.color.r = color.r        --Red
        self.color.g = color.g        --Green
        self.color.b = color.b        --Blue
        self.color.a = color.a or 255 --Alpha

        self.mode    = mode or "line" --Mode
        
    end
}


--Return functions
return shape