# Clean Modules

A [Factorio](https://factorio.com) mod that adds versions of the vanilla modules without their
maluses.

A clean module keeps only the positive effects of the module it copies, at a reduced strength — so a
Clean Speed Module gives speed without the quality penalty, and a Clean Productivity Module gives
productivity without the speed and energy penalties. Covers speed, productivity, efficiency and
quality modules across tiers 1-3, skipping any whose source mod isn't installed (quality modules
without the Quality mod, for instance).

This mod is standalone — it does not require the Momentum Modules library.

## Startup settings

| Setting | Default | Description |
| --- | --- | --- |
| Clean effect strength | 0.9 | How strong a clean module's remaining effects are compared to the module it's copied from. Range 0.2-1.0. |
| Extra ingredient 1 / amount | 5 electronic circuits | Item added to every clean module recipe, on top of the module it's made from. Leave blank to skip. |
| Extra ingredient 2 / amount | none | A second optional item ingredient. |
| Fluid ingredient / amount | none (25) | Optional fluid added to every clean module recipe. |

## Dependencies

- Factorio 2.0+
- Optional: Space Age, Quality

## Related mods

- [Momentum Modules](https://github.com/SirRolin/Factorio-momentum-modules) (library)
- [Momentum Modules - Turbo](https://github.com/SirRolin/Factorio-momentum-turbo)
- [Momentum Modules - Catalytic](https://github.com/SirRolin/Factorio-momentum-catalytic)
- [Momentum Modules - Threshold](https://github.com/SirRolin/Factorio-momentum-threshold)

## Installation

Clone or copy this folder into your Factorio `mods` directory as
`sir-rolins-clean-modules_<version>`, or install it from the in-game mod portal.
