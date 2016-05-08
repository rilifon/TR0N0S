--Change players from CPU to HUMAN with a controller
function player_button()
    --Human with WASD controls, on click, becomes ARROWS if possible, else becomes CPU
    if not p.cpu and p.control == "WASD" then
        if ARROWS_PLAYER == 0 then
            p.control = "ARROWS"
            ARROWS_PLAYER = p.number
            WASD_PLAYER = 0
        else
            p.cpu = true
            p.level = 1
            p.control = nil
            WASD_PLAYER = 0
        end

    --Human with ARROWS controls, on click, becomes CPU Level1
    elseif not p.cpu and p.control == "ARROWS" then
        p.cpu = true
        p.level = 1
        p.control = nil
        ARROWS_PLAYER = 0

    --CPU Level different from 3, on click, becomes next level CPU
    elseif p.cpu and p.level ~= 3 then
        p.level = p.level + 1

    --CPU Level3, on click, becomes WASD or ARROWS if possible. Else becomes CPU Level1
    elseif p.cpu and p.level == 3 then
        if WASD_PLAYER == 0 then
            p.control = "WASD"
            WASD_PLAYER = p.number
            p.cpu = false
            p.level = nil
        elseif ARROWS_PLAYER == 0 then
            p.control = "ARROWS"
            ARROWS_PLAYER = p.number
            p.cpu = false
            p.level = nil
        else
            p.level = 1
        end
    end

    --Update player text
    if p.cpu then
        cputext = "CPU"
        controltext = "Level " .. p.level
    else
        cputext = "HUMAN"
        controltext = p.control
    end
    PB_T["P"..p.number.."pb"].text =  "PLAYER " .. p.number .. " " .. cputext .. " (" .. controltext .. ")"

end

return player_button