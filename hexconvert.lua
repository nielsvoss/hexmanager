require('hexparsing')
require('hexprocessing')

HexConvert = {}

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

function HexConvert.compile(s)
   local tokens = HexParsing.tokenize(s)
   local ast = HexParsing.tokens_to_ast(tokens)
   local iotas = HexProcessing.process(ast)
   return iotas
end

local sample = [[
- 2
- 25; - "The quick brown fox"
{ - null; - null }
Scribe's Reflection
]]

--print_table(HexConvert.compile(sample))
