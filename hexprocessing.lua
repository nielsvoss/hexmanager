require('hexpatterns')

HexProcessing = {}

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

    local asnumber = tonumber(symbol)
    if asnumber then
        return asnumber
    end

    local vector_res, _, x_str, y_str, z_str =
        string.find(symbol, "%<([%-%.%w]*),%s*([%-%.%w]*),%s*([%-%.%w]*)%>")
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

    local string_res, _, str = string.find(symbol, '^%"(.*)%"$')
    if string_res then
        -- TODO: String escape codes
        return str
    end

    -- TODO: Entities, Iota Types, Entity Types, Gates, Motes, Matricies

    error("Unknown nonpattern symbol")
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

    local pattern = HexPatterns.from_translation(symbol)
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
