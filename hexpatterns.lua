HexPatterns = {}

local csv = require("packages/csv")
local parameters = {
    header = true
}
local f = csv.open("data/patterns.csv", parameters)
assert(f ~= nil)

local pattern_table = {}
for fields in f:lines() do
    table.insert(pattern_table, fields)
end

function HexPatterns.pattern_from_translation(name)
    for _,pattern in ipairs(pattern_table) do
        if pattern.translation == name then
            return pattern
        end
    end
    return nil
end
