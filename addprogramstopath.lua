local path = "/hexmanager/programs"
if  shell.path():match(path) then
    print("Shell path already contains "..path)
else
    local new_path = shell.path()..":"..path
    shell.setPath(new_path)
    print("Added "..path.." to shell path")
end
