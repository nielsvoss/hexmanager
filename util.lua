Util = {}

-- https://stackoverflow.com/a/27028488
function Util.table_to_string(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. Util.table_to_string(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

function Util.print_table(o)
  print(Util.table_to_string(o))
end
