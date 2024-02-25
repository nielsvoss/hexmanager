SelectionScreen = {}

local up_arrow_key = 265
local down_arrow_key = 264
local right_arrow_key = 262
local left_arrow_key = 263
local enter_key = 257

local function draw_menu(menu_items, current_selection, index_at_top, max_number_to_display)
    term.clear()

    local number_to_display = math.min(max_number_to_display, #menu_items - index_at_top + 1)
    for i = 1, number_to_display do
        local item_number = i + index_at_top - 1

        -- Leave a blank line for the text box
        term.setCursorPos(1, i + 1)

        local item = menu_items[item_number]
        if item_number == current_selection then
            term.write("> "..item)
        else
            term.write("  "..item)
        end
    end

    term.setCursorPos(1, 1)
end

function SelectionScreen.menu(menu_items)
    local current_selection = 1
    local index_at_top = 1

    local _, height = term.getSize()
    local number_to_display = height - 1

    draw_menu(menu_items, current_selection, index_at_top, number_to_display)
    local sEvent, nKey = os.pullEvent('key')
    while nKey ~= enter_key do
        if nKey == down_arrow_key then
            current_selection = math.min(current_selection + 1, #menu_items)
        elseif nKey == up_arrow_key then
            current_selection = math.max(current_selection - 1, 1)
        end

        -- Scroll screen up and down
        local index_at_bottom = index_at_top + number_to_display - 1
        if current_selection < index_at_top then
            index_at_top = current_selection
        elseif current_selection > index_at_bottom then
            index_at_top = current_selection - number_to_display + 1
        end

        draw_menu(menu_items, current_selection, index_at_top, number_to_display)

        sEvent, nKey = os.pullEvent('key')
    end

    term.clear()
    return current_selection
end

local menu_items = {}
for i=1,20 do
    table.insert(menu_items, i)
end
print(SelectionScreen.menu(menu_items))
