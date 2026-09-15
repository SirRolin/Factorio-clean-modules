-- Local copy of the momentum core's module list (this mod works without it).
-- Kept local and returned, so it doesn't clash with the core's global getModuleList.

-- effectName is the name that's going to be used.
-- baseName is the name the game knows it as.
-- baseColour is the tint that it is approximated.
-- lightColour is the tint for the lights colour.
-- tier2 (optional) is if the tier2 module doesn't have the same naming scheme as vanilla. Set to 0 to skip.
-- tier3 (optional) same as tier 2.
local function getModule(effectName, baseName, baseColour, lightColour, tier2, tier3)
  return {
    name = effectName,
    tier1 = util.table.deepcopy(data.raw.module[baseName]),
    tier2 = tier2 ~= 0 and util.table.deepcopy(data.raw.module[tier2 or baseName .. "-2"]) or nil,
    tier3 = tier3 ~= 0 and util.table.deepcopy(data.raw.module[tier3 or baseName .. "-3"]) or nil,
    baseColour = baseColour,
    lightColour = lightColour,
  }
end

local function getModuleList()
  local modules = {}

  local function add(module)
    -- Skips modules from mods that aren't installed (e.g. quality modules without the quality mod).
    if module.tier1 then
      table.insert(modules, module)
    end
  end

  add(getModule("speed",        "speed-module",        { r = 0.45, g = 0.65, b = 1.0 },  { r = 0.45, g = 0.65, b = 1.0 }))
  add(getModule("productivity", "productivity-module", { r = 1.0,  g = 0.45, b = 0.1 },  { r = 1.0, g = 0.6,  b = 0.2 }))
  add(getModule("efficiency",   "efficiency-module",   { r = 0.3,  g = 0.85, b = 0.3 },  { r = 0.3, g = 0.85,  b = 0.3 }))
  add(getModule("quality",      "quality-module",      { r = 0.9, g = 0.9, b = 0.9 }, { r = 1.0, g = 0.0, b = 0.0 }))

  return modules
end

return getModuleList
