
--Function that changes player 'n' text
function changeText(n)
    local p, controltext

    p = P_T[n]


    p.name = "OMAR"
    
    if p.cpu then
        controltext = "Level " .. p.level
    else
        controltext = p.control
    end

    PB_T["P"..p.number.."pb"].text =  p.name .. " (" .. controltext .. ")"
end


return changeText