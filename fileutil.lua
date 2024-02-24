FileUtil = {}

local is_computer_craft = not not fs

local function get_directory(file_path)
    local _, _, directory = file_path:find("^(.*/)[^/]*$")
    return directory or ''
end

function FileUtil.read_local_file(path, current_file_path)
    local directory = ""
    if current_file_path then
        directory = get_directory(current_file_path)
    end

    local f = io.open(directory..path)
    if f then
        return f:read('*a')
    else
        error('Could not locate file "'..directory..path..'"')
    end
end
