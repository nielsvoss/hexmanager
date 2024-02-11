HexNumbers = {}

local number_table = {
    ['-1'] = 'deddw',
    ['0'] = 'aqaa',
    ['1/4'] = 'aqaawdd',
    ['1/2'] = 'aqaawd',
    ['1'] = 'aqaaw',
    ['2'] = 'aqaawa',
}

function HexNumbers.get_angles(number_as_string)
    return number_table[number_as_string]
end

function HexNumbers.get_pattern(number_as_string)
    local angles = HexNumbers.get_angles(number_as_string)
    if angles then
        local startDir = "SOUTH_EAST"
        -- If the number is negative, it should start flipped vertically
        if string.sub(angles, 1, 1) == "d" then
            startDir = "NORTH_EAST"
        end
        return {
            angles = angles,
            startDir = startDir
        }
    end
    return nil
end
