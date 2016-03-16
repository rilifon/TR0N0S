--MODULE FOR BUTTONS AND STUFF--
local Util    = require "util"


local button = {}

--Button object
But = Class{
	init = function(self, x, y, w, h, text, font, b_color, t_color, func)
		self.x     = x     --x position
		self.y     = y     --y position
		self.w     = w     --width
		self.h     = h     --height
		self.text  = text  --text on button
	    self.font  = font  --size of text
	    --Color of box
        self.b_color = {}
        self.b_color.r = b_color.r
        self.b_color.g = b_color.g
        self.b_color.b = b_color.b
        --Color of text
        self.t_color = {}
        self.t_color.r = t_color.r
        self.t_color.g = t_color.g
        self.t_color.b = t_color.b 
		self.func  = func  --function to call when pressed

	end
}

function button.setup()
	--Button table
	B_T = {}
	local x, y, w, h, font
	local gap = 5 --Gap between two buttons
	local color_b = COLOR(233, 131, 0)
	local color_t = COLOR(0, 0, 0)
	w = 160
	h = 60
	font = font_but_m

	--N_PLAYERS BUTTON
	x = 300
	y = 20
	n_player_up = But(x, y, w, h, "+", font, color_b, color_t,
		function()		
			if N_PLAYERS < MAX_PLAYERS then
				N_PLAYERS = N_PLAYERS + 1
				--Insert new CPU player
				local rgb_b = COLOR(math.random(255), math.random(255), math.random(255))
				local rgb_h = COLOR(math.random(255), math.random(255), math.random(255))
				local P   = PLAYER(N_PLAYERS, false, nil, nil, nil, nil, rgb_b, rgb_h, true, 1, nil)
				table.insert(P_T, P)
				Util.updatePlayersBox()
			end
		end)
	table.insert(B_T, n_player_up)
	n_player_down = But(x, y + h + gap, w, h, "-", font, color_b, color_t,
		function()
			if N_PLAYERS > 1 then
				table.remove(P_T, N_PLAYERS)
				N_PLAYERS = N_PLAYERS - 1
				Util.updatePlayersBox()
			end
		end)
	table.insert(B_T, n_player_down)

end

--Check if a mouse click collides with any button
function button.checkCollision(x,y)
	for i,v in ipairs(B_T) do
		if 	v.x <= x
			and
			x <= v.x + v.w
			and
			v.y <= y
			and
			y <= v.y + v.h then

			v.func()
		end

	end
end


return button