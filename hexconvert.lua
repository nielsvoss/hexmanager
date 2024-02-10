local function tokenize(text)
    local tokens = {}
    for line in string.gmatch(text, "[^\n]+") do
        local comment_start_loccation = string.find(line, "//")
        if (comment_start_loccation) then
            line = string.sub(line, 1, comment_start_loccation - 1)
        end

        table.insert(tokens, line)
    end
    return tokens
end

local sample = [[
The quick brown fox // this is a comment
Jumps; Over the; Lazy; Dog
]]

print(table.concat(tokenize(sample), ", "))
