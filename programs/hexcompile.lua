local path_to_script = debug.getinfo(1).source
local base_directory = path_to_script:match("^@(.*)[/\\]programs[/\\].*%.lua$")
package.path = package.path..";"..base_directory.."/?.lua"

require('hexconvert')

local args = {...}
if not args[1] then
   print('Please provide a file name!')
   return 1
end

local path = shell.resolve(args[1])
local handle = fs.open(path, 'r')
if not handle then
    print('Failed to open file')
    return 1
end

local program = ""
local line = handle.readLine()
while line ~= nil do
    program = program..line.."\n"
    line = handle.readLine()
end

print('Compiling hex program...')
local status,iotas = pcall(function()
    local processing_environment = { current_file_path = path }
    return HexConvert.compile(program, processing_environment)
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
