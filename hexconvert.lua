local function trim(s)
  local l = 1
  while string.sub(s, l, l) == ' ' do
    l = l + 1
  end
  local r = string.len(s)
  while string.sub(s, r, r) == ' ' do
    r = r - 1
  end
  return string.sub(s, l, r)
end

local function tokenize(text)
    local tokens = {}
    for line in string.gmatch(text, "[^\n]+") do
        local comment_start_loccation = string.find(line, "//")
        if comment_start_loccation then
            line = string.sub(line, 1, comment_start_loccation - 1)
        end

        for segment in string.gmatch(line, "[^;]+") do
            local bracket_index = string.find(segment, "[{}]")
            while bracket_index do
                table.insert(tokens, trim(string.sub(segment, 1, bracket_index - 1)))
                table.insert(tokens, string.sub(segment, bracket_index, bracket_index))
                segment = string.sub(segment, bracket_index + 1)
                bracket_index = string.find(segment, "[{}]")
            end
            table.insert(tokens, trim(segment))
        end
    end
    return tokens
end

local sample = [[
The quick brown fox // this is a comment
Jumps; Over { the; Lazy; Dog }
]]

print(table.concat(tokenize(sample), ", "))
