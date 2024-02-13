HexNumbers = {}

local number_table = {
    -- TODO: Remove negatives from the table and just flip the first 4 angles on positives
    ['-2'] = 'deddwa',
    ['-1'] = 'deddw',
    ['-1/2'] = 'deddwd',
    ['0'] = 'aqaa',
    ['1/8'] = 'aqaawdaddadd',
    ['1/4'] = 'aqaawdd',
    ['3/8'] = 'aqaawdwdd',
    ['1/2'] = 'aqaawd',
    ['5/8'] = 'aqaaqwddwdd',
    ['3/4'] = 'aqaawdwd',
    ['7/8'] = 'aqaaqdwdd',
    ['1'] = 'aqaaw',
    ['3/2'] = 'aqaawdw',
    ['13/8'] = 'aqaawdwqdd', -- Between player sneak and standing height
    ['2'] = 'aqaawa',
    ['3'] = 'aqaaedwd',
    ['4'] = 'aqaawaa',
    ['5'] = 'aqaaq',
    ['6'] = 'aqaaedw',
    ['7'] = 'aqaawaq',
    ['8'] = 'aqaawaqw',
    ['9'] = 'aqaawaaq',
    ['10'] = 'aqaae',
    ['11'] = 'aqaaqaw',
    ['12'] = 'aqaaqwa',
    ['13'] = 'aqaawqaw',
    ['14'] = 'aqaawaaqq',
    ['15'] = 'aqaaedaq',
    ['16'] = 'aqaaqawq',
    ['17'] = 'aqaaqwaq',
    ['18'] = 'aqaawaaqa',
    ['19'] = 'aqaawaaqe',
    ['20'] = 'aqaaee',
    ['30'] = 'aqaaeaqq',
    ['40'] = 'aqaaqqaa',
    ['50'] = 'aqaaeaqa',
    ['100'] = 'aqaaeaqaa',
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
