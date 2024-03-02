# Hex Manager

A ComputerCraft program to write and manage
[Hex Casting](https://www.curseforge.com/minecraft/mc-mods/hexcasting)
spells, using
[Ducky Peripherals](https://www.curseforge.com/minecraft/mc-mods/ducky-periphs).

Hex Manager offers a simple programming language to write Hex casting spells, which reduces the risk
of error and makes developing more complex spells easier.
For example, here is the code for a simple spell to blink the caster forward 5 blocks:
```
get_caster
number: 5
Blink
```

Patterns can be written in their id form (like `get_caster`) or using their full name (like `Blink`).
(A list of patterns for Hex Casting and some of its addons is found in this spreadsheet:
https://object-object.github.io/HexBug/patterns.csv).
More information about the programming language is provided below.

This spell should be written to a file on a ComputerCraft computer, and a focal port should be
be placed on the right side of the computer. Place a focus into the focal port and use `hexcompile`
on your file to get the spell into the focus.

## Requirements

- [Hex Casting](https://www.curseforge.com/minecraft/mc-mods/hexcasting)
- [CC: Tweaked](https://www.curseforge.com/minecraft/mc-mods/cc-tweaked)
- [Ducky Peripherals](https://www.curseforge.com/minecraft/mc-mods/ducky-periphs).

This program has only been tested on the Fabric 1.20.1 version of these mods, but other versions
might work as well.
