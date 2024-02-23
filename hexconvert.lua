require('hexparsing')
require('hexprocessing')
require('hexdecode')
require('hexdirectives')

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
   HexDirectives.run_directives(ast)
   local iotas = HexProcessing.process(ast)
   return iotas
end

function HexConvert.decompile_to_lines(iota)
   if type(iota) ~= 'table' or (iota ~= {} and not iota[1]) then
      local lines = HexDecode.decode_iotas({iota})
      table.insert(lines, 1, "// Warning: this Iota was originally not a list, but will be written back as a single element list")
      return lines
   else
      return HexDecode.decode_iotas(iota)
   end
end

function HexConvert.decompile(iota)
   return table.concat(HexConvert.decompile_to_lines(iota), "\n")
end
