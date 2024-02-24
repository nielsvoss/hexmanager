FileUtil = {}

local is_computer_craft = not not fs

local function get_directory(file_path)
    local _, _, directory = file_path:find("^(.*/)[^/]*$")
    return directory or ''
end

function FileUtil.read_local_file(path, current_file_path)
    if path == '' then
        error("Path must be nonempty")
    end

    local directory = ""
    if current_file_path and path:sub(1,1) ~= '/' then
        directory = get_directory(current_file_path)
    end

    local f = io.open(directory..path)
    if f then
        return f:read('*a')
    else
        error('Could not open file "'..directory..path..'"')
    end
end
