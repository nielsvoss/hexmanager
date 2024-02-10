require('hexparsing')

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

local sample = [[
The quick brown fox // this is a comment
Jumps; Over { the; Lazy; Dog }
]]

local ast = HexParsing.tokens_to_ast(HexParsing.tokenize(sample))
print_table(ast)
