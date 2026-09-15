-- Factorio doesn't re-apply a technology's unlocks when a mod adds new ones to it, so
-- clean module recipes added to already researched technologies have to be enabled by hand.
local function unlock_researched_recipes()
    for _, force in pairs(game.forces) do
        for _, tech in pairs(force.technologies) do
            if tech.researched then
                for _, effect in pairs(tech.prototype.effects) do
                    if effect.type == "unlock-recipe" and effect.recipe:find("^sr%-clean%-") then
                        force.recipes[effect.recipe].enabled = true
                    end
                end
            end
        end
    end
end

script.on_init(unlock_researched_recipes)
script.on_configuration_changed(unlock_researched_recipes)
