SelectionScreen = {}

local up_arrow_key = 265
local down_arrow_key = 264
local right_arrow_key = 262
local left_arrow_key = 263
local enter_key = 257
local backspace_key = 259

local function draw_menu(menu_items, current_selection, index_at_top, max_number_to_display, header)
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
    term.write(header)
end

function SelectionScreen.menu(menu_items, prompt)
    local _, height = term.getSize()
    local number_to_display = height - 1

    local current_selection = 1
    local index_at_top = 1
    local filter_text = ''
    local filter_text_just_updated = true

    local filtered_menu_items
    local corresponding_indicies

    while true do
        if filter_text_just_updated then
            filtered_menu_items = {}
            corresponding_indicies = {}

            for i,item in ipairs(menu_items) do
                if item:sub(1, #filter_text) == filter_text then
                    table.insert(filtered_menu_items, item)
                    table.insert(corresponding_indicies, i)
                end
            end

            current_selection = 1
            index_at_top = 1
            filter_text_just_updated = false
        end

        draw_menu(filtered_menu_items, current_selection, index_at_top, number_to_display, prompt..filter_text)
        local event, p1 = os.pullEvent()

        if event == 'key' then
            if p1 == enter_key then
                break
            elseif p1 == backspace_key then
                if #filter_text > 0 then
                    filter_text = filter_text:sub(1, #filter_text - 1)
                end
                filter_text_just_updated = true
            elseif p1 == down_arrow_key then
                current_selection = math.min(current_selection + 1, #menu_items)
            elseif p1 == up_arrow_key then
                current_selection = math.max(current_selection - 1, 1)
            end
        elseif event == 'char' then
            filter_text = filter_text..p1
            filter_text_just_updated = true
        end

        -- Scroll screen up and down
        local index_at_bottom = index_at_top + number_to_display - 1
        if current_selection < index_at_top then
            index_at_top = current_selection
        elseif current_selection > index_at_bottom then
            index_at_top = current_selection - number_to_display + 1
        end
    end

    term.clear()
    term.setCursorPos(1, 1)
    return corresponding_indicies[current_selection]
end

local menu_items = {}
for i=1,20 do
    table.insert(menu_items, ''..i)
end
print(SelectionScreen.menu(menu_items, "select: "))
