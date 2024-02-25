require('util')

HexConfig = {}

local path_to_this_file = debug.getinfo(1).source
local base_directory = path_to_this_file:match("^@(.*)hexconfig%.lua$")
local config_file_path = base_directory..'config.txt'

local function get_config_file_contents()
    local f = io.open(config_file_path, 'r')
    local text = ''
    if f then
        text = f:read('*a')
        f:close()
    end

    return text:gsub('\r\n', '\n')
end

function HexConfig.get(option_name)
    local text = get_config_file_contents()

    for line in text:gmatch("[^\n]+") do
        local option, value = text:match("([^\n]*)=([^\n]*)")
        if option and Util.trim(option) == option_name then
            return Util.trim(value)
        end
    end

    return ''
end

function HexConfig.set(option_name, new_value)
    local text = get_config_file_contents()
    local new_lines = {}
    local did_update_value = false

    for line in text:gmatch("[^\n]+") do
        local option, current_value = line:match("(.*)=(.*)")
        if option and Util.trim(option) == option_name then
            table.insert(new_lines, option_name..' = '..new_value)
            did_update_value = true
        else
            table.insert(new_lines, Util.trim(option)..' = '..Util.trim(current_value))
        end
    end

    if not did_update_value then
        table.insert(new_lines, option_name..' = '..new_value)
    end

    local new_text = table.concat(new_lines, '\n')

    local f = io.open(config_file_path, 'w')
    if not f then
        error('Unable to write to config file: "'..config_file_path..'"')
    end

    f:write(new_text)
    f:close()
end
