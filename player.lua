--MODULE FOR PLAYERS AND STUFF--

local Util    = require "util"

local player = {}

--PLayer object
PLAYER = Class{
    init = function(self, number, dead, x, y, dir, nextdir, b_color, h_color, cpu, level, control, score)
        self.number = number   --player number
        self.dead = dead       --if player is dead
        self.x = x             --x position
        self.y = y             --y position
        self.dir = dir         --player current direction
        self.nextdir = nextdir --player next direction
        
        --Color of player's body
        self.b_color ={}
        self.b_color.r = b_color.r
        self.b_color.g = b_color.g
        self.b_color.b = b_color.b
        --Color of player's head
        self.h_color ={}
        self.h_color.r = h_color.r
        self.h_color.g = h_color.g
        self.h_color.b = h_color.b        

        self.cpu = cpu   --boolean that indicates if player is cpu
        if self.cpu then
        	self.level   = level --cpu level
        	self.control = nil   
        else
        	self.level = nil
        	self.control = control --indicates this player controls ("WASD" or "ARROWS")
        end
    end
}


--Return functions
return player