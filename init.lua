-- /run ChatFrame1:Clear()
-- /console scriptErrors 1

-- namespace
local _, core = ...
core.Init = {}
local Init = core.Init


-- addon "globals"
Init.PREFIX = "Undying Legacy Loot:"
Init.PRINT_PREFIX = string.format("|cff00ccff%s|r", Init.PREFIX)