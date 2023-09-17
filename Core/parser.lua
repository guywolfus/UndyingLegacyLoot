-- namespace
local _, core = ...
core.Parser = {}
local Parser = core.Parser

-- WoW APIs
local _G = _G


-- build array from csv string
local function ConstructArray(unparsed_str)
    local construct_array = {}
    for word in string.gmatch(unparsed_str, '([^,]+)') do
        table.insert(construct_array, word)
    end
    return construct_array
end

-- return actual string or actual nil
local function StrActual(str)
    if str == "nil" then return nil else return str end
end

-- parser method
function Parser:ParseText(unparsed_str, print_done)
    local loot_prio_table = _G.ULL_LootPrioTable or {}

    -- strip the header to get the number of columns
    local header_str
    for line in string.gmatch(unparsed_str, '([^\n]+)') do header_str = line break end
    local stripped_input_text = unparsed_str:gsub(header_str, "")
    header_str = header_str:lower():gsub(" ", "") -- strip spaces 
    header_str = header_str:gsub(",,", ",nil,"):gsub(",,", ",nil,") -- add nils

    -- validate the necessary headers
    local validate_itemname  = core.Utils:StrExists("itemname", header_str)
    if not validate_itemname then
        core.Utils:Print("|cffff2222Error: Failed to parse the import string, doesn't include \"Item Name\" in the header.|r")
        return
    end
    local validate_priority  = core.Utils:StrExists("priority", header_str)
    if not validate_priority then
        core.Utils:Print("|cffff2222Error: Failed to parse the import string, doesn't include \"Priority\" in the header.|r")
        return
    end

    -- find the indices of "itemname" and "priority"
    local header_array = ConstructArray(header_str) -- no. of columns is #header_array
    local itemname_index = core.Utils:getIndex("itemname", header_array)
    local priority_index = core.Utils:getIndex("priority", header_array)
    if not itemname_index or not priority_index then
        core.Utils:Print("|cffff2222Error: Failed to parse the import string, missing indices for header attributes.|r")
        return
    end

    -- reconfigure the text for parsing
    stripped_input_text = stripped_input_text:gsub("\"\n", "\"") -- strip unnecessary new line breaks
    local quoted_values_table = {} -- replace commas in quoted values with a modified placeholder
    local i = 0
    for quoted_value in stripped_input_text:gmatch("([^\"]*)\"") do
        i = i + 1 -- grab only every 2nd match, so we know we're looking at cells where the commas are textual
        if (i % 2) == 0 and core.Utils:StrExists(",", quoted_value) then
            quoted_values_table[quoted_value] = quoted_value:gsub(",", "__comma__")
        end
    end
    for quoted_value, modified_quoted_value in pairs(quoted_values_table) do -- apply the modified placeholders to the input text
        stripped_input_text = stripped_input_text:gsub(quoted_value, modified_quoted_value)
    end
    stripped_input_text = stripped_input_text:gsub(",,", ",nil,"):gsub(",,", ",nil,") -- add nils

    -- go over the stripped input text
    for line in string.gmatch(stripped_input_text, '([^\n]+)') do
        local input_words_array = ConstructArray(line)
        local itemname, priority = nil, nil
        for i = 1, #input_words_array do
            local columns_mod = i % #header_array

            -- catch itemname
            if columns_mod == itemname_index then
                itemname = StrActual(input_words_array[i])
            end

            -- catch priority
            if columns_mod == priority_index then
                priority = StrActual(input_words_array[i])
            end

            if itemname and priority then
                -- restore commas to itemnames and priorities
                itemname = itemname:gsub("__comma__", ","):gsub("\"", "")
                priority = priority:gsub("__comma__", ","):gsub("\"", "")

                -- prompt if previous loot prio existed
                -- local previous_priority = _G.ULL_LootPrioTable[itemname] or nil
                -- if previous_priority and previous_priority ~= priority then
                --     core.Utils:Print(string.format("Priority changed for [%s]", itemname))
                -- end

                -- add itemnames and priorities to the table and reset
                loot_prio_table[itemname] = priority
                itemname, priority = nil, nil
            end
        end
    end

    if print_done then core.Utils:Print("Imported successfully!") end
    return loot_prio_table
end

function Parser:GetLootPrio(itemname)
    if not _G.ULL_LootPrioTable then
        core.Utils:Print("|cffff2222Error: SavedVariable of the Loot Prio is empty. Did you import successfully?|r")
    end
    return StrActual(_G.ULL_LootPrioTable[itemname]) or nil
end