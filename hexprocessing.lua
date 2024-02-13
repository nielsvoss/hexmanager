require('hexpatterns')
require('hexnumbers')

HexProcessing = {}

local function try_parse_function_call_syntax(text, name)
    local res, _, str = string.find(text, "^"..name.."%((.*)%)$")
    if res then
        return str
    else
        return nil
    end
end

local function try_parse_vector_iota(text)
    local vector_res, _, x_str, y_str, z_str =
        string.find(text, "^%<([%-%.%w]*),%s*([%-%.%w]*),%s*([%-%.%w]*)%>$")
    if vector_res then
        local x = tonumber(x_str)
        local y = tonumber(y_str)
        local z = tonumber(z_str)
        if x and y and z then
            return {
                x = x,
                y = y,
                z = z
            }
        else
            error("Invalid number in vector")
        end
    end
    return nil
end

local function try_parse_string_iota(text)
    local string_res, _, str = string.find(text, '^%"(.*)%"$')
    if string_res then
        -- TODO: String escape codes
        return str
    end
    return nil
end

function HexProcessing.process_nonpattern(symbol)
    if symbol == 'null' then
        return {
            null = true
        }
    elseif symbol == 'garbage' then
        return {
            garbage = true
        }
    elseif symbol == 'true' then
        return true
    elseif symbol == 'false' then
        return false
    end

    local entity_uuid = try_parse_function_call_syntax(symbol, "entity")
    if entity_uuid then
        return {
            uuid = entity_uuid
        }
    end

    local iota_type = try_parse_function_call_syntax(symbol, "iota_type")
    if iota_type then
        return {
            iotaType = iota_type
        }
    end

    local entity_type = try_parse_function_call_syntax(symbol, "entity_type")
    if entity_type then
        return {
            entityType = entity_type
        }
    end

    local gate_uuid = try_parse_function_call_syntax(symbol, "gate")
    if gate_uuid then
        return {
            gate = gate_uuid
        }
    end

    local item_type = try_parse_function_call_syntax(symbol, "item_type")
    if item_type then
        return {
            isItem = true,
            itemType = item_type
        }
    end

    local asnumber = tonumber(symbol)
    if asnumber then return asnumber end

    local vector_res = try_parse_vector_iota(symbol)
    if vector_res then return vector_res end

    local string_res = try_parse_string_iota(symbol)
    if string_res then return string_res end

    -- TODO: Entities, Iota Types, Entity Types, Gates, Motes, Matricies

    error("Unknown nonpattern symbol")
end

local function bookkeepers_gambit_angles(code)
    if string.len(code) == 0 then error("Code needs at least one character") end
    local last_index_was_bend = false
    local angles = ""
    for c in code:gmatch('.') do
        if c == '-' then
            if last_index_was_bend then
                angles = angles..'e'
            else
                angles = angles..'w'
            end
            last_index_was_bend = false
        elseif c == 'v' then
            if last_index_was_bend then
                angles = angles..'da'
            else
                angles = angles..'ea'
            end
            last_index_was_bend = true
        else
            error("Invalid character in code")
        end
    end

    return string.sub(angles, 2)
end

local function bookkeepers_gambit_pattern(code)
    if string.len(code) == 0 then error("Code needs at least one character") end

    local angles = bookkeepers_gambit_angles(code)
    local startDir = "EAST"
    if code:sub(1,1) == 'v' then
        startDir = "SOUTH_EAST"
    end

    return {
        angles = angles,
        startDir = startDir
    }
end

local valid_angles = {
    ["EAST"] = true,
    ["NORTH_EAST"] = true,
    ["NORTH_WEST"] = true,
    ["WEST"] = true,
    ["SOUTH_WEST"] = true,
    ["SOUTH_EAST"] = true
}

local function parse_angles(text)
    -- Check if both the angles and starting direction are specified
    local startDir_with_angles_res, _, startDir, angles1 = string.find(text, "^(%u+)_([aqwed]*)$")
    if startDir_with_angles_res then
        if not valid_angles[startDir] then error("Invalid direction "..startDir) end
        return {
            startDir = startDir,
            angles = angles1
        }
    end

    local angles_res, _, angles2 = string.find(text, "^([aqwed]*)$")
    if angles_res then
        return {
            startDir = "EAST",
            angles = angles2
        }
    end

    error("Failed to parse angles")
end

function HexProcessing.process_pattern(symbol)
    -- Check if pattern angles are specified explicitly
    local angles_res, _, angles = string.find(symbol, "%(([%w_]*)%)$")
    if angles_res then
        return parse_angles(angles)
    end

    local number_string = string.match(symbol, "Numerical Reflection: (.*)$") or
        string.match(symbol, "number: (.*)$")
    if number_string then
        local number_pattern = HexNumbers.get_pattern(number_string)
        if number_pattern then
            return number_pattern
        else
            error('Number "'..number_string..'" not available in quick-reference table, must enter manually')
        end
    end

    local bookkeepers_gambit = symbol:match("Bookkeeper's Gambit: ([-v]+)$") or
        symbol:match("mask: ([-v]+)")
    if bookkeepers_gambit then
        return bookkeepers_gambit_pattern(bookkeepers_gambit)
    end

    local pattern = HexPatterns.from_name(symbol)
    if not pattern then
        error('Unknown pattern "'..symbol..'"')
    end

    if HexPatterns.is_dynamic(pattern) then
        error('Pattern "'..symbol..'" requires the angles to be explicitly specified')
    end

    return {
        startDir = pattern.direction,
        angles = pattern.pattern
    }
end

function HexProcessing.process(nodes)
    local iotas = {}
    for _,node in ipairs(nodes) do
        if node.token_type == 'pattern' then
            table.insert(iotas, HexProcessing.process_pattern(node.value))
        elseif node.token_type == 'nonpattern' then
            table.insert(iotas, HexProcessing.process_nonpattern(node.value))
        elseif node.token_type == 'list' then
            if node.delimiter == '[' then
                table.insert(iotas, HexProcessing.process(node.elements))
            elseif node.delimiter == '{' then
                table.insert(iotas, HexProcessing.process_pattern("Introspection"))
                for _,iota in ipairs(HexProcessing.process(node.elements)) do
                    table.insert(iotas, iota)
                end
                table.insert(iotas, HexProcessing.process_pattern("Retrospection"))
            else
                error("Unknown list delimiter")
            end
        else
            error("Unknown node type")
        end
    end
    return iotas
end
