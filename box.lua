--MODULE FOR BOX AND STUFF--

box = {}

local box = {}

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

--Return functions
return box