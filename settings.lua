local prefix = "sr-clean-recipe-"

-- Extra recipe ingredients shared by every clean module, on top of the module it's made from.
local recipeDefaults = {
    items = {
        { item = "electronic-circuit", amount = 5 },
    },
    fluid = nil,
}

local settingsPackage = {
    {
        type = "double-setting",
        name = "sr-clean-effect-scaling",
        setting_type = "startup",
        order = "a",
        default_value = 0.9,
        minimum_value = 0.2,
        maximum_value = 1.0,
    },
}

for i = 1, 2 do
    local default = recipeDefaults.items[i]
    table.insert(settingsPackage, {
        type = "string-setting",
        name = prefix .. "item-" .. i,
        setting_type = "startup",
        allow_blank = true,
        order = string.format("b-recipe-%d-a", i),
        default_value = default and default.item or "",
        localised_name = { "mod-setting-name.sr-clean-recipe-item", tostring(i) },
    })
    table.insert(settingsPackage, {
        type = "int-setting",
        name = prefix .. "amount-" .. i,
        setting_type = "startup",
        order = string.format("b-recipe-%d-b", i),
        default_value = default and default.amount or 1,
        minimum_value = 1,
        localised_name = { "mod-setting-name.sr-clean-recipe-amount", tostring(i) },
    })
end

local fluid = recipeDefaults.fluid or {}
table.insert(settingsPackage, {
    type = "string-setting",
    name = prefix .. "fluid",
    setting_type = "startup",
    allow_blank = true,
    order = "b-recipe-3-a",
    default_value = fluid.fluid or "",
    localised_name = { "mod-setting-name.sr-clean-recipe-fluid" },
})
table.insert(settingsPackage, {
    type = "int-setting",
    name = prefix .. "fluid-amount",
    setting_type = "startup",
    order = "b-recipe-3-b",
    default_value = fluid.amount or 25,
    minimum_value = 1,
    localised_name = { "mod-setting-name.sr-clean-recipe-fluid-amount" },
})

data:extend(settingsPackage)
