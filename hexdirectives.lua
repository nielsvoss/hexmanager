require('util')

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

HexDirectives.directive_table = {
    ["directive_info"] = directive_info_directive,
    ["msg"] = msg_directive
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
