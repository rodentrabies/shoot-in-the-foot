# Shoot in the Foot

Every time you're about to shoot yourself in the foot by using the greatest
programming tool ever - **THE MACRO**, this handy minor mode warns you by
reloading the limb-shooting macroshotgun.

## Installation
Clone this repository to your load path and use your preferred way to load
it. After that, the mode can be enabled by running `M-x shoot-in-the-foot`
command.

## Configuration
Currently, only `defmacro` and `macrolet` symbols are considered dangerous, but
this can be customized via `shoot-in-the-foot-dangerous-symbols` variable.
