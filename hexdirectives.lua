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
end

local function msg_directive(argument, all_nodes, nodes_in_scope, directive_index, processing_environment)
    print(argument)
end

HexDirectives.directive_table = {
    ["directive_info"] = directive_info_directive,
    ["msg"] = msg_directive
}

local function run_directives_aux(all_nodes, nodes_in_scope, processing_environment)
    for i,node in ipairs(nodes_in_scope) do
        if node.token_type == 'directive' then
            local directive = HexDirectives.directive_table[node.directive_name]
            if not directive then
                error('Unknown directive "#'..node.directive_name..'"')
            end
            directive(node.argument, all_nodes, nodes_in_scope, i, processing_environment)
            nodes_in_scope[i] = {
                token_type = 'noop'
            }
        elseif node.token_type == 'list' then
            run_directives_aux(all_nodes, node.elements, processing_environment)
        end
    end
end

function HexDirectives.run_directives(nodes, processing_environment)
    run_directives_aux(nodes, nodes, processing_environment)
end
