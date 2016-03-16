--MODULE FOR PLAYERS AND STUFF--

local Util    = require "util"

local player = {}

--PLayer object
PLAYER = Class{
    init = function(self, number, dead, x, y, dir, nextdir, b_color, h_color, cpu, level, control)
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

        self.cpu   = cpu   --boolean that indicates if player is cpu
        if self.cpu then
        	self.level   = level --cpu level
        	self.control = nil   
        else
        	self.level = nil
        	self.control = control --indicates this player controls ("WASD" or "ARROWS")
        end
    end
}

--Setup the first two players
function player.setup()
	P_T = {}   --Players table
	PTB_T = {} --PLayers TextBox table

	local rgb_b, rgb_h  --Color for body and head
	
	--Player 1
	rgb_b = COLOR(233, 131,  0)
	rgb_h = COLOR(255, 161, 30)
	local P_1   = PLAYER(1, false, nil, nil, nil, nil, rgb_b, rgb_h, false, nil, "WASD")
	table.insert(P_T, P_1)

	--Player 2
	rgb_b = COLOR(125, 0,  99)
	rgb_h = COLOR(255, 30, 129)
	local P_2   = PLAYER(2, false, nil, nil, nil, nil, rgb_b, rgb_h, false, nil, "ARROWS")
	table.insert(P_T, P_2)

	--Creates textboxes for current players
	Util.updatePlayersBox()

end
--Return functions
return player