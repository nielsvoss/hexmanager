require('hexpatterns')

HexDecode = {}

function HexDecode.decode_pattern(pattern)
    local angles = pattern.angles
    local pattern = HexPatterns.from_angles(angles)
    if pattern then
        if HexPatterns.is_dynamic(pattern) then
            return pattern.translation..' ('..angles..')'
        else
            return pattern.translation
        end
    end

    if angles:match("^aqaa") or angles:match("^dedd") then
       return 'Numerical Reflection ('..angles..')'
    end

    return 'Unknown ('..angles..')'
end
