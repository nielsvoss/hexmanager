local base64 = require('packages.base64')

FileUtil = {}

local path_to_this_file = debug.getinfo(1).source
local base_directory = path_to_this_file:match("^@(.*)fileutil%.lua$")
local webcache_directory = base_directory..'webcache/'

local base64encoder = base64.makeencoder('+','-','_')

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

--[[
local function validate_url(url)
    if not http then
        error('Internet files only work from ComputerCraft, and with the http variable non-nil')
    end

    local success, message = http.checkURL(url)
    if not success then
        error("Invalid URL: " .. message)
    end
end
]]

local function write_into_webcache(url, text)
    local filename = webcache_directory..base64.encode(url, base64encoder)
    local file = io.open(filename, 'w')
    if not file then
        error('Could not open "'..filename..'"')
    end

    file:write(text)
    file:close()
end

local function read_from_webcache(url)
    local filename = webcache_directory..base64.encode(url, base64encoder)
    local file = io.open(filename, 'r')
    if not file then
        return nil
    end

    local text = file:read('a')
    file:close()
    return text
end

function FileUtil.read_web_file(url)
    --validate_url(url)
    local result = http.get(url)
    if result then
        local text = result.readAll()
        result.close()
        write_into_webcache(url, text)
        return text
    else
        print('Warning: Cannot connect to ' .. url .. '. Attempting to reach from webcache...')
        local text = read_from_webcache(url)
        if not text then
            error('Unable to retrieve webpage from webcache')
        end
        print('Retrived webpage from webcache')
        return text
    end
end
