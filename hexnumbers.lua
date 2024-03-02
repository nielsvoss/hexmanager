HexNumbers = {}

local number_table = {
    [0] = 'aqaa',
    [1/8] = 'aqaawdaddadd',
    [1/4] = 'aqaawdd',
    [3/8] = 'aqaawdwdd',
    [1/2] = 'aqaawd',
    [5/8] = 'aqaaqwddwdd',
    [3/4] = 'aqaawdwd',
    [7/8] = 'aqaaqdwdd',
    [1] = 'aqaaw',
    [3/2] = 'aqaawdw',
    [13/8] = 'aqaawdwqdd', -- Between player sneak and standing height
    [2] = 'aqaawa',
    [3] = 'aqaaedwd',
    [4] = 'aqaawaa',
    [5] = 'aqaaq',
    [6] = 'aqaaedw',
    [7] = 'aqaawaq',
    [8] = 'aqaawaqw',
    [9] = 'aqaawaaq',
    [10] = 'aqaae',
    [11] = 'aqaaqaw',
    [12] = 'aqaaqwa',
    [13] = 'aqaawqaw',
    [14] = 'aqaawaaqq',
    [15] = 'aqaaedaq',
    [16] = 'aqaaqawq',
    [17] = 'aqaaqwaq',
    [18] = 'aqaawaaqa',
    [19] = 'aqaawaaqe',
    [20] = 'aqaaee',
    [30] = 'aqaaeaqq',
    [40] = 'aqaaqqaa',
    [50] = 'aqaaeaqa',
    [100] = 'aqaaeaqaa',
}

local function to_number(number_as_string)
    local numerator, denom = number_as_string:match('([^/]*)/([^/]*)')
    if numerator and denom then
        local numerator_as_number = to_number(numerator)
        local denom_as_number = to_number(denom)
        if numerator_as_number and denom_as_number then
            return numerator_as_number / denom_as_number
        else
            return nil
        end
    end

    return tonumber(number_as_string)
end

local function get_angles(number_as_string)
    local number = to_number(number_as_string)
    if not number then
        return nil
    end
    local is_negative = number < 0
    number = math.abs(number)

    for key,angles in pairs(number_table) do
        local tolerance = 0.00000001
        if math.abs(number - key) <= tolerance then
            if is_negative then
                return angles:gsub('^aqaa', 'dedd', 1)
            end
            return angles
        end
    end
    return nil
end

function HexNumbers.get_pattern(number_as_string)
    local angles = get_angles(number_as_string)
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
