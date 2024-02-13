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

function HexDecode.decode_nonlist(iota)
    if type(iota) == 'number' then
        return '- '..tostring(iota)
    elseif type(iota) == 'boolean' then
        return '- '..tostring(iota)
    elseif type(iota) == 'string' then
        return '- "'..iota..'"'
    elseif iota.angles then
       return HexDecode.decode_pattern(iota)
    elseif iota.null then
        return "- null"
    elseif iota.garbage then
        return "- garbage"
    elseif iota.x and iota.y and iota.z then
        return '<'..tostring(iota.x)..', '..tostring(iota.y)..', '..tostring(iota.z)..'>'
    elseif iota.uuid then
        return '- entity('..iota.uuid..') // Entity name: '..iota.name
    elseif iota.iotaType then
        return '- iota_type('..iota.iotaType..')'
    elseif iota.entityType then
        return '- entity_type('..iota.entityType..')'
    elseif iota.gate then
        return '- gate('..iota.gate..')'
    elseif iota.moteUuid then
        return '- garbage // Motes are currently unsupported by the decoder'
    elseif iota.matrix then
        return '- garbage // Matricies are currently unsuppored by the decoder'
    else
        return '- garbage // Unrecognized Iota Type'
    end
end

local function decode_iotas_aux(iotas, indentation_level)
    local lines = {}
    for _,iota in ipairs(iotas) do
        local indentation = string.rep(' ', 4 * indentation_level)

        -- Check if iota is a list
        if type(iota) == 'table' and (iota == {} or iota[1]) then
            table.insert(lines, indentation..'[')
            for _,line in ipairs(decode_iotas_aux(iota, indentation_level + 1)) do
                table.insert(lines, line)
            end
            table.insert(lines, indentation..']')
        else
            local decoded = HexDecode.decode_nonlist(iota)
            if decoded == 'Introspection' then
                table.insert(lines, indentation..'{')
                indentation_level = indentation_level + 1
            elseif decoded == 'Retrospection' then
                if indentation_level > 0 then
                    indentation_level = indentation_level - 1
                end
                indentation = string.rep(' ', 4 * indentation_level)
                table.insert(lines, indentation..'}')
            else
                table.insert(lines, indentation..decoded)
            end
        end
    end
    return lines
end


function HexDecode.decode_iotas(iotas)
   return decode_iotas_aux(iotas, 0)
end
