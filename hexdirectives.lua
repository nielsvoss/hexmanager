require('util')
require('fileutil')
require('hexparsing')

HexDirectives = {}

local function directive_info_directive(argument, all_nodes, nodes_in_scope, directive_index, processing_environment)
    print('Argument: "'..argument..'"')
    print('All nodes:')
    Util.print_table(all_nodes)
    print('Nodes in scope:')
    Util.print_table(nodes_in_scope)
    print('Directive index: '..directive_index)
    print('Processing Environment:')
    Util.print_table(processing_environment)
    return false
end

local function msg_directive(argument, all_nodes, nodes_in_scope, directive_index, processing_environment)
    print(argument)
    return false
end

local function alias_directive(argument, all_nodes, nodes_in_scope, directive_index, processing_environment)
    local _, _, alias_name, pattern_name = argument:find("^([%w%s_]*)=([%w%s%p%(%)_]*)$")
    if not alias_name or not pattern_name then
        error('Invalid alias declaration "'..argument..'"')
    end

    local alias_name_trimmed = Util.trim(alias_name)
    local pattern_name_trimmed = Util.trim(pattern_name)

    if alias_name_trimmed == '' or pattern_name_trimmed == '' then
        error('#alias requires something on both sides of the equal sign')
    end

    if not processing_environment.alias_table then
        processing_environment.alias_table = {}
    end
    processing_environment.alias_table[alias_name_trimmed] = pattern_name_trimmed
    return false
end

local function include_code(nodes_in_scope, index, text)
    local tokens = HexParsing.tokenize(text)
    local ast = HexParsing.tokens_to_ast(tokens)

    -- First we remove all nodes after the #include directive, and store them to add back later
    -- nodes_after_include will be in reverse order
    local nodes_after_include = {}
    for _=index+1,#nodes_in_scope do
        table.insert(nodes_after_include, table.remove(nodes_in_scope))
    end

    -- Then we add the new nodes to the end of the node list
    for _,node in ipairs(ast) do
        table.insert(nodes_in_scope, node)
    end

    -- Now we add back the nodes we removed earlier
    for i=#nodes_after_include,1,-1 do
        table.insert(nodes_in_scope, nodes_after_include[i])
    end
end

local function include_directive(argument, all_nodes, nodes_in_scope, directive_index, processing_environment)
    if argument == '' then
        error("#include requires a file name")
    end

    if not processing_environment.current_file_path then
        error('(Internal error, please report) Processing environment did not contain the file name')
    end

    local text = FileUtil.read_local_file(argument, processing_environment.current_file_path)
    include_code(nodes_in_scope, directive_index, text)

    return true
end

HexDirectives.directive_table = {
    ["directive_info"] = directive_info_directive,
    ["msg"] = msg_directive,
    ["alias"] = alias_directive,
    ["include"] = include_directive
}

-- This function returns true if one of the directives modified the node tree in a suck a way that
-- that it needs to restart from the start of the file. This could happen if extra directives are
-- inserted near the front of the file.
local function run_directives_aux(all_nodes, nodes_in_scope, processing_environment)
    for i,node in ipairs(nodes_in_scope) do
        if node.token_type == 'directive' then
            local directive = HexDirectives.directive_table[node.directive_name]
            if not directive then
                error('Unknown directive "#'..node.directive_name..'"')
            end
            node.token_type = 'noop'
            local requires_reprocess =
                directive(node.argument, all_nodes, nodes_in_scope, i, processing_environment)
            if requires_reprocess then
                return true
            end
        elseif node.token_type == 'list' then
            local requires_reprocess =
                run_directives_aux(all_nodes, node.elements, processing_environment)
            if requires_reprocess then
                return true
            end
        end
    end
end

function HexDirectives.run_directives(nodes, processing_environment)
    local max_tries = 64
    local i = 1
    local requires_reprocess = true
    while requires_reprocess and i <= max_tries do
        requires_reprocess = run_directives_aux(nodes, nodes, processing_environment)
        i = i + 1
    end
    if requires_reprocess then
        error("Max number of file reprocesses reached")
    end
end
