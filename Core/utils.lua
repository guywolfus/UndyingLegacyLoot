-- namespace
local _, core = ...
core.Utils = {}
local Utils = core.Utils

-- WoW APIs
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local GetItemInfo = GetItemInfo


-- private functions
function Utils:_PrintLootPrio()
    for test_itemname, test_priority in pairs(_G.ULL_LootPrioTable) do
        print("[" .. test_itemname .. "]: " .. test_priority)
    end
    core.Utils:Print("_PrintLootPrio")
end

function Utils:_ResetSavedVariable()
    _G.ULL_LootPrioTable = {}
    core.Utils:Print("_ResetSavedVariable")
end


-- print to console
function Utils:Print(...)
    DEFAULT_CHAT_FRAME:AddMessage(string.join(" ", core.Init.PRINT_PREFIX, ...))
end

-- str exists in str
function Utils:StrExists(validate_str, in_str)
    local _, exists = in_str:gsub(validate_str, "")
    if exists > 0 then return true else return false end
end

-- get index of key in table
function Utils:getIndex(val, tbl)
    for k, v in pairs(tbl) do
        if v == val then
            return k
        end
    end
    return nil
end

-- validate if a string is an item link
function Utils:IsItemLink(item_link)
    return GetItemInfo(item_link) ~= nil
end

-- return item name from item link
function Utils:GetItemNameFromLink(item_link)
    local item_name, _ = GetItemInfo(item_link)
    return item_name
end