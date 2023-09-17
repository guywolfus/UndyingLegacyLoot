-- namespace
local _, core = ...
core.UI = {}
local UI = core.UI

-- AceGUI APIs
local AceGUI = LibStub("AceGUI-3.0")

-- WoW APIs
local _G = _G


-- instanciate the UI
UI.Instance = nil
function UI:ImportLootUI()
    if UI.Instance then
        return
    else
        UI:ImportLoot()
    end
end

-- create the window
function UI:ImportLoot()

    -- main frame container
    local main_frame = AceGUI:Create("Window")
    main_frame:SetCallback("OnClose", function(widget)
        AceGUI:Release(widget)
        UI.Instance = nil
    end)
    main_frame:SetTitle("Undying Legacy Loot: Import")
    main_frame:SetLayout("Fill")
    main_frame:SetWidth(400)
    main_frame:SetHeight(560)

    -- edit box widget
    local editbox = AceGUI:Create("MultiLineEditBox")
    editbox:SetCallback("OnEnterPressed", function(widget, event, text)
        _G.ULL_LootPrioTable = core.Parser:ParseText(text, true)
        AceGUI:Release(main_frame)
        UI.Instance = nil
    end)
    editbox:SetLabel("Insert CSV:")
    main_frame:AddChild(editbox)

    -- assign the window to the namespace reference
    UI.Instance = main_frame

end