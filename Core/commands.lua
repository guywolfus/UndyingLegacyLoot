-- namespace
local _, core = ...
core.Commands = {}
local Commands = core.Commands

-- WoW APIs
local GetItemInfo, ChatFrame1  = GetItemInfo, ChatFrame1
local GetUnitName, SendChatMessage = GetUnitName, SendChatMessage


-- slash command arguments
Commands.arguments = {
    ["help"] = function(...) Commands:PrintHelpOptions() end,
    ["options"] = function(...) Commands:PrintHelpOptions() end,

    ["import"] = core.UI.ImportLootUI,

    ["print"] = function(...) SendMessageByChatType(nil, ...) end,
    ["say"] = function(...) SendMessageByChatType("SAY", ...) end,
    ["s"] = function(...) SendMessageByChatType("SAY", ...) end,
    ["yell"] = function(...) SendMessageByChatType("YELL", ...) end,
    ["y"] = function(...) SendMessageByChatType("YELL", ...) end,
    ["party"] = function(...) SendMessageByChatType("PARTY", ...) end,
    ["p"] = function(...) SendMessageByChatType("PARTY", ...) end,
    ["guild"] = function(...) SendMessageByChatType("GUILD", ...) end,
    ["g"] = function(...) SendMessageByChatType("GUILD", ...) end,
    ["officer"] = function(...) SendMessageByChatType("OFFICER", ...) end,
    ["o"] = function(...) SendMessageByChatType("OFFICER", ...) end,
    ["raid"] = function(...) SendMessageByChatType("RAID", ...) end,
    ["ra"] = function(...) SendMessageByChatType("RAID", ...) end,
    ["raidwarning"] = function(...) SendMessageByChatType("RAID_WARNING", ...) end,
    ["rw"] = function(...) SendMessageByChatType("RAID_WARNING", ...) end,
    ["whisper"] = function(...) SendMessageByChatType("WHISPER", ...) end,
    ["w"] = function(...) SendMessageByChatType("WHISPER", ...) end,

    ["debug_reset"] = function(...) core.Utils:_ResetSavedVariable() end,
    ["debug_print"] = function(...) core.Utils:_PrintLootPrio() end,
}

-- print help options to console
function Commands:PrintHelpOptions()
    core.Utils:Print("Commands:")
    print("|cff00cc66/ull import|r - opens an interface to import external loot prio table")
    print("|cff00cc66/ull [item]|r")
    print("|cff00cc66/ull say [item]|r")
    print("|cff00cc66/ull yell [item]|r")
    print("|cff00cc66/ull party [item]|r")
    print("|cff00cc66/ull guild [item]|r")
    print("|cff00cc66/ull officer [item]|r")
    print("|cff00cc66/ull raid [item]|r")
    print("|cff00cc66/ull raidwarning [item]|r")
    print("|cff00cc66/ull whisper [item]|r")
end

-- get ID from item_link
function Commands:GetItemnameID(msg)
    print(msg)
    local something, link = GetItemInfo(msg)
    print(something, link)
    if link then
        ChatFrame1:AddMessage(msg .. " has item ID: " .. link:match("item:(%d+):"))
    end
end

-- send message by chat type
function SendMessageByChatType(chat_type, item_link)
    -- validate item link
    if not core.Utils:IsItemLink(item_link) then
        core.Utils:Print(string.format("|cffff2222Error: %s is not a valid item link.|r", item_link))
        return
    end

    -- get prio for the item link
    local itemname = core.Utils:GetItemNameFromLink(item_link)
    local priority = core.Parser:GetLootPrio(itemname) or "FFA"

    -- send the messahe appropriately
    if not chat_type then
        core.Utils:Print(string.join(" ", item_link, priority))
    else
        local channel = GetUnitName("player")
        if GetUnitName("target") ~= nil then
            channel = GetUnitName("target")
        end
        SendChatMessage(string.join(" ", core.Init.PREFIX, item_link, priority), chat_type, nil, channel)
    end
end