-- Clean modules: copies of every module in the module list without their negative effects,
-- with the remaining effects scaled by the sr-clean-effect-scaling setting.
-- e.g. sr-clean-speed-module-2 = speed module 2 without the consumption and quality maluses.

local getModuleList = require("lib.module_list")
local scaling = settings.startup["sr-clean-effect-scaling"].value

-- Positive consumption/pollution and negative everything else are maluses.
local function isMalus(key, value)
    if key == "consumption" or key == "pollution" then
        return value > 0
    end
    return value < 0
end

-- The item name the momentum core's module list expects: <name>, <name>-2, <name>-3.
local function cleanName(entry, tier)
    return "sr-clean-" .. entry.name .. "-module" .. (tier == 1 and "" or "-" .. tier)
end

-- Shares the momentum core's "Modules" tab when it's installed, or creates it.
if not data.raw["item-group"]["sr-mom-modules"] then
    data:extend({
        {
            type = "item-group",
            name = "sr-mom-modules",
            order = "ca",
            icon = "__base__/graphics/icons/speed-module.png",
            icon_size = 64,
        },
    })
end

-- Returns the names of every technology that unlocks a recipe producing itemName.
local function findUnlockTechnologies(itemName)
    local recipes = {}
    for recipeName, recipe in pairs(data.raw.recipe) do
        if recipe.category ~= "recycling" then
            for _, result in pairs(recipe.results or {}) do
                if result.name == itemName then recipes[recipeName] = true end
            end
        end
    end
    local technologies = {}
    for techName, tech in pairs(data.raw.technology) do
        for _, effect in pairs(tech.effects or {}) do
            if effect.type == "unlock-recipe" and recipes[effect.recipe] then
                table.insert(technologies, techName)
                break
            end
        end
    end
    return technologies
end

-- 1 of the base module + the extra ingredients from the recipe settings.
local function getRecipe(name, baseModule)
    local prefix = "sr-clean-recipe-"
    local ingredients = {{ type = "item", name = baseModule.name, amount = 1 }}
    for i = 1, 2 do
        local item = settings.startup[prefix .. "item-" .. i].value
        if item ~= "" then
            local amount = settings.startup[prefix .. "amount-" .. i].value
            local existing = nil
            for _, ingredient in pairs(ingredients) do
                if ingredient.name == item then existing = ingredient end
            end
            if existing then
                existing.amount = existing.amount + amount
            else
                table.insert(ingredients, { type = "item", name = item, amount = amount })
            end
        end
    end
    local fluid = settings.startup[prefix .. "fluid"].value
    local hasFluid = fluid ~= ""
    if hasFluid then
        table.insert(ingredients, { type = "fluid", name = fluid, amount = settings.startup[prefix .. "fluid-amount"].value })
    end

    local category
    if mods["space-age"] then
        category = hasFluid and "electronics-with-fluid" or "electronics"
    else
        category = hasFluid and "crafting-with-fluid" or "crafting"
    end

    return {
        type = "recipe",
        name = name,
        category = category,
        enabled = false,
        energy_required = 15 * 2 ^ ((baseModule.tier or 1) - 1),
        ingredients = ingredients,
        results = {{ type = "item", name = name, amount = 1 }},
        allow_decomposition = true,
    }
end

local package = {}
local strength = tostring(math.floor(scaling * 100 + 0.5))

for _, entry in pairs(getModuleList()) do
    local subgroupName = "sr-mom-base-clean-" .. entry.name
    if not data.raw["item-subgroup"][subgroupName] then
        -- "<category>--clean" sorts right after the base modules' row ("<category>-") in the tab.
        table.insert(package, {
            type = "item-subgroup",
            name = subgroupName,
            group = "sr-mom-modules",
            order = entry.tier1.category .. "--clean",
        })
    end

    for tier = 1, 3 do
        local base = entry["tier" .. tier]
        if base then
            local name = cleanName(entry, tier)
            local baseLocalisedName = base.localised_name or { "item-name." .. base.name }

            local module = util.table.deepcopy(base)
            module.name = name
            module.localised_name = { "sr-clean.name", baseLocalisedName }
            module.localised_description = { "sr-clean.description", baseLocalisedName, strength }
            module.subgroup = subgroupName
            module.order = string.format("a[%d]", tier)
            module.effect = {}
            for key, value in pairs(base.effect or {}) do
                if not isMalus(key, value) then
                    module.effect[key] = value * scaling
                end
            end
            table.insert(package, module)

            local recipe = getRecipe(name, base)
            local technologies = findUnlockTechnologies(base.name)
            for _, techName in pairs(technologies) do
                local tech = data.raw.technology[techName]
                tech.effects = tech.effects or {}
                table.insert(tech.effects, { type = "unlock-recipe", recipe = name })
            end
            if #technologies == 0 then recipe.enabled = true end
            table.insert(package, recipe)
        end
    end
end

data:extend(package)
