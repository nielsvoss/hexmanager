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

## Installation

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

After installation, you should see the directory `hexmanager`. It comes with a few commands located
in `hexmanager/programs/`, notably `hexcompile`.

To avoid having to type out the full path to the programs every time you want to compile a spell,
run `hexmanager/addprogramstopath`. You may wish to set this to run on startup.

## Usage

Hex Manager comes with the following spells:
- `hexcompile` - The primary program used to load spells from a file into a focus
- `hexdecompile` - Loads a spell off a focus and writes it to a file. This is currently fairly
rudimentary and doesn't produce the highest quality spells, but it can be handy.
- `hexcloud` - Advanced spell manager for those who want to manage a large collection of spells
somewhere on the internet (e.g. a Google Drive).

### `hexcompile`

`hexcompile` is the primary program in Hex Manager. To use it, first edit a file like
```
edit myspell.hex
```
Write a spell, as described in the language guide below. Then save the file.
The file does not need to end in `.hex`, but doing so helps distinguish it from other types of
files.

Craft a Focal Port from
Ducky Peripherals and place it on the right side of the computer (in the future, I might add an
option to configure the side on which the Focal Port is attached).

Now run
```
hexcompile myspell.hex
```

If you get a "No such program" message, make sure that you have run `hexmanager/addprogramstopath`
since the last time you started up the computer.

If you get a success message, then you are all set. Feel free to take your focus out of the focal
port and use it to cast a spell.

### `hexdecompile`

This program does the opposite of `hexcompile`. It takes a spell in a focus and writes it to a file.

To use, first write a list of iotas to the focus (if you write a single iota rather than a list of
iotas, it will be interpreted as a singleton list). Place the focus into a Focal Port on the right
side of the computer. Then run
```
hexdecompile filetostorespell.hex
```
`filetostorespell.hex` will be created and the spell will be written to it. It does not need to end
in `.hex`.

*Warning: This process will overwrite existing files without prompting.*

By default, `hexdecompile` creates files using the full names of patterns
(e.g. `Mind's Reflection`). If you want it to use the short id names instead (e.g. `get_caster`),
then create or edit the file `hexmanager/config.txt` so that it contains the line:
```
use_short_names_when_decoding = true
```

The decompiler is very rudimentary, and it contains some major limitations which might be fixed in
the future, including:
- It cannot detect usages of `Bookkeeper's Gambit` or Great Spells, so they show up as `Unknown`.
The pattern angles are still stored so this doesn't prevent you from recompiling.
- Numbers are not identified when decoding.
The pattern angles are still stored so this doesn't prevent you from recompiling.

### `hexcloud`

`hexcloud` is a more advanced program that lets you store large collections of spells on the
internet rather than your ComputerCraft computer.

To use it, create a "Spell Index" file on the internet with contents like:
```
Spell Name: https://url/of/spell
Spell Name: https://url/of/spell
Spell Name: https://url/of/spell
```

This Spell Index file can be located anywhere on the internet, but there must be a url to download
it as a plain text document. Each url within the Spell Index must also refer to a plain text
document, this time containing a spell (like one you might compile using `hexcompile`).

Google Docs have special handling, so you can use urls like
`https://docs.google.com/document/d/1HZCLY58-O6JxoZ-z9Wg4wj2kVSSTd1sn8DwSucZvnlY/edit`
directly without worrying about plain text as either your Spell Index or an individual spell, or
both. The Google Doc needs to be shared so that anyone with the link can view it.
Some small details, like converting from the curly quotes normally typed into Google Docs and
the straight quotes accepted by Hex Manager are handled for you.

Why would you store spells in Google Docs? I don't know, but you can do it if you want. Other good
options for storing spells include GitHub (which currently requires you to use the
`raw.githubusercontent.com` links. This may change in the future.)

In any case, get the link to your Spell Index file, and create or edit the `hexmanager/config.txt`
file so that it contains:
```
hexcloud_url = https://url/of/spell/index
```

Finally, you can run the command `hexcloud` with no arguments.
If everything has been done properly, and the ComputerCraft machine has access to the internet, then
it will display the list of spells in your index, letting you select them with arrow keys or by
typing to filter. Choose a spell, and it will be compiled as if you had download it and run
`hexcompile` on it.
