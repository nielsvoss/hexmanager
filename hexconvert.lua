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

local function insert_trimmed_if_nonempty(t, str)
  local str_trimmed = trim(str)
  if str_trimmed ~= "" then
    table.insert(t, str_trimmed)
  end
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
                insert_trimmed_if_nonempty(tokens, string.sub(segment, 1, bracket_index - 1))
                table.insert(tokens, string.sub(segment, bracket_index, bracket_index))
                segment = string.sub(segment, bracket_index + 1)
                bracket_index = string.find(segment, "[{}]")
            end
            insert_trimmed_if_nonempty(tokens, segment)
        end
    end
    return tokens
end

-- https://stackoverflow.com/a/27028488
local function table_to_string(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. table_to_string(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function print_table(o)
  print(table_to_string(o))
end

local function non_bracket_token_to_ast(token)
  if string.match(token, "^-") then
    local _, _, remaining = string.find(token, "-(.*)")
    return {
      token_type = 'nonpattern',
      value = trim(remaining)
    }
  else
    return {
      token_type = 'pattern',
      value = trim(token)
    }
  end
end

local function tokens_to_ast(tokens)
    
end

local sample = [[
The quick brown fox // this is a comment
Jumps; Over { the; Lazy; Dog }
]]

print_table(non_bracket_token_to_ast("- asdf"))
