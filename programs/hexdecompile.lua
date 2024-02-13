local path_to_script = debug.getinfo(1).source
local base_directory = path_to_script:match("^@(.*)[/\\]programs[/\\].*%.lua$")
package.path = package.path..";"..base_directory.."/?.lua"

require('hexconvert')

print("Reading from Focal Port on right side...")
local focal_port = peripheral.wrap('right')
if not focal_port or not focal_port.readIota then
    print('Focal port not attached to right side.')
    return 1
end
local iota = focal_port.readIota()

if iota then
    print("Successfully read iotas")
else
    print("Failed to read itoas")
    return 1
end

print("Decompiling hex program...")
local status,program_lines_or_err = pcall(function()
    return HexConvert.decompile_to_lines(iota)
end)
if status then
    print('Decompiled hex program.')
else
    print('Error: '..program_lines_or_err)
    return 1
end

local args = {...}
if args[1] then
    print("Writing to file...")
    local path = shell.resolve(args[1])
    local handle = fs.open(path, 'w')
    if not handle then
        print("Failed to open file for writing")
        return 1
    end
    for _,line in ipairs(program_lines_or_err) do
        handle.writeLine(line)
    end
    handle.writeLine("") -- Write empty extra line at the end
    handle.close()
    print("Successfully wrote to file")
else
    print("No file name provided, printing to console")
    print()
    print("Spell:")
    print()
    print(table.concat(HexConvert.decompile_to_lines(iota), "\n"))
end
