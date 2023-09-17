-- namespace
local _, core = ...

-- WoW APIs
local _G = _G
local CreateFrame = CreateFrame


-- parse slash command
local function SlashCommandParser(command_input)

    -- ignore if no input
    if #command_input == 0 then return end

    -- parse command input to args
    local slash_cmds = core.Commands.arguments
    local slash_cmd = "print"
    local args = {string.split(" ", command_input)}
    local arg1 = args[1]:lower()

    -- first arg is a slash command
    if slash_cmds[arg1] and type(slash_cmds[arg1]) == "function" then
        slash_cmd = arg1
        command_input = command_input:gsub(arg1 .. " ", "")
    end

    -- execute command or show help
    if not slash_cmd and not command_input then
        core.Utils:Print("|cffff2222Error: Wrong syntax, use \"/ull help\" for the list of options.|r")
    else
        slash_cmds[slash_cmd](command_input)
    end
end

-- load the addon
function core:LoadAddon(_, name)
    if (name ~= "UndyingLegacyLoot") then return end

    -- register slash commands
    SLASH_UndyingLegacyLoot1 = "/ull"
    SlashCmdList.UndyingLegacyLoot = SlashCommandParser
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", core.LoadAddon)