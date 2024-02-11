HexPatterns = {}

local csv = require("packages/csv")
local parameters = {
    header = true
}

-- This code to find the script location is necessary because ComputerCraft uses absolute paths
local path_to_script = debug.getinfo(1).source
local directory_containing_script = string.match(path_to_script, "^@(.*)[/\\].*%.lua$")
local f = csv.open(directory_containing_script.."/data/patterns.csv", parameters)
assert(f ~= nil)

local pattern_table = {}
for fields in f:lines() do
    table.insert(pattern_table, fields)
end

function HexPatterns.from_translation(name)
    for _,pattern in ipairs(pattern_table) do
        if pattern.translation == name then
            return pattern
        end
    end
    return nil
end

function HexPatterns.from_short_name(name)
    for _,pattern in ipairs(pattern_table) do
        if pattern.name == name then
            return pattern
        end
    end
    return nil
end

function HexPatterns.from_name(name)
    return HexPatterns.from_translation(name) or HexPatterns.from_short_name(name)
end

function HexPatterns.from_angles(angles)
    for _,pattern in ipairs(pattern_table) do
        if pattern.pattern == angles then
            return pattern
        end
    end
    return nil
end

function HexPatterns.is_dynamic(pattern)
    -- The == 'true' is necessary because pattern.is_great is a string and is still true when 'false'
    return pattern.is_great == 'true' or pattern.pattern == ''
end
