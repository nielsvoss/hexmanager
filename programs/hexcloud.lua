local path_to_script = debug.getinfo(1).source
local base_directory = path_to_script:match("^@(.*)[/\\]programs[/\\].*%.lua$")
package.path = package.path..";"..base_directory.."/?.lua"

require('hexconvert')
require('hexconfig')
require('fileutil')

local url = HexConfig.get('hexcloud_url')
if url == '' then
    print("hexcloud_url not set in config.txt")
    return 1
end

local text = FileUtil.read_web_file(url)
text = text:gsub('\r\n', '\n')
local hexes = {}
for line in text:gmatch("[^\n]+") do
    local name, hex_url = line:match("^([^:]*):(.*)$")
    if name then
        table.insert(hexes, { name = Util.trim(name), url = Util.trim(hex_url) })
    end
end

-- Selection menu
local up_arrow_key = 265
local down_arrow_key = 264
local right_arrow_key = 262
local left_arrow_key = 263
local enter_key = 257

local function draw_menu(cursor_pos)
    term.clear()
    for i,hex in ipairs(hexes) do
        if i == cursor_pos then
            print("> "..hex.name)
        else
            print("  "..hex.name)
        end
    end
end

local selected = 1
draw_menu(1)
local sEvent, nKey = os.pullEvent('key')
while nKey ~= enter_key do
    if nKey == down_arrow_key then
        selected = math.min(selected + 1, #hexes)
    elseif nKey == up_arrow_key then
        selected = math.max(selected - 1, 1)
    end
    draw_menu(selected)
    sEvent, nKey = os.pullEvent('key')
end

local hex = hexes[selected]
print('Selected "'..hex.name..'"')
print('Downloading hex program...')
local program = FileUtil.read_web_file(hex.url)

print('Compiling hex program...')
local status,iotas = pcall(function()
    return HexConvert.compile(program, {})
end)
if status then
    print('Compiled hex program.')
else
    print('Error: '..iotas)
    return 1
end

print('Writing to Focal Port on right side...')
local focal_port = peripheral.wrap('right')
if not focal_port or not focal_port.writeIota then
    print('Focal port not attached to right side.')
    return 1
end

local res = focal_port.writeIota(iotas)
if res then
    print("Successfully wrote iotas")
else
    print("Failed to write iotas")
    return 1
end
