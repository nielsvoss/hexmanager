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

function Util.trim(s)
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
