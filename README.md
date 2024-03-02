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

# Installation

To install Hex Manager, you will need a way to download GitHub repositories onto your ComputerCraft
computer. One such way you can do this is by installing
[`computercraft-github`](https://github.com/eric-wieser/computercraft-github)
by running the following command (as suggested in `computercraft-github`'s README):
```
pastebin run p8PJVxC4
```

Note that `computercraft-github` is currently unmaintained, so if you have trouble, please try using
one of its forks or another project to download from github.

After installing `computercraft-github`, run the following command to download Hex Manager:
```
github clone osbourn/hexmanager
```

Make sure you are in the root directory before running either of the above commands.

After installation, you should see the directory `hexmanager` be created. It comes with the
following commands located in `hexmanager/programs/`:
- `hexcompile` - The primary program used to load spells into a focus
- `hexdecompile` - Loads a spell of the focus and writes it to a file. This is currently fairly
rudimentary and doesn't produce the highest quality spells, but it can be handy.
- `hexcloud` - Advanced spell manager for those who want to manage a large collection of spells
somewhere on the internet (e.g. a Google Drive).

To avoid having to type out the full path to the programs every time you want to compile a spell,
run `hexmanager/addprogramstopath`. You may wish to set this to run on startup.
