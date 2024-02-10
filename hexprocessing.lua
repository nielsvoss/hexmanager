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
