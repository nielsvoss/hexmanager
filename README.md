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

After installing `computercraft-github`, run the following command to download Hex Manager
version 0.1:
```
github clone nielsvoss/hexmanager -t v0.1
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
`raw.githubusercontent.com` links. This may change in the future).

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

`hexcloud` uses a cache for webpages. This can help if you lose internet connection for some reason,
but it means that Hex Manager will use an outdated version of a file rather than failing, which can
be frustrating if you don't notice this happening.

## The Hex Programming Language

The custom programming language used by Hex Manager for writing spells is fairly simple, but has a
few advanced features.

### Basic Syntax

Each line represents one iota, except maybe in the case of lists. Semicolons split lines like line
breaks. The semicolon (as well as a few characters) can be escaped with a backslash, although the
instances in which you would need to do this are quite rare.

`//` starts a comment, which lasts until the end of the line.

### Patterns

Most lines that don't start with `-`, `#`, or a bracket are normal patterns. Each line represents
a single pattern.

To represent a pattern iota, write the name of a pattern literally. This can be either the name
found directly in the Hex Notebook, or the shortened id name used internally by Hex Casting.
The list of patterns, along with their full and id names, is available in this spreadsheet:
https://object-object.github.io/HexBug/patterns.csv

Sometimes minor discrepancies occur between the names in the spreadsheet and the Hex Notebook,
especially for minor details like apostrophes. When in doubt, the spreadsheet is correct, because
that is what this program uses internally.

The spreadsheet in this project might be out of date. If so, please file an issue on this
repository.

#### More details

If you add parentheses after a pattern name, the pattern name will be ignored and whatever was
inside the parentheses will be treated as the pattern angles. This can be used to represent any
patttern if it is unavailable for some reason.

For example:
```
True Reflection (dedq) // The spell ignores "True Reflection" and casts dedq, which represents "False Reflection"
True Reflection (SOUTH_WEST_dedq) // Optionally specifiy direction
```

This is currently required for Great Spells, which have a different pattern every world.

There is special handling for `Numerical Reflection` and `Bookkeeper's Gambit`:
- If you write `Numerical Reflection: 6` or `number: 6`, then it will add the pattern needed to
put the number `6` on to the stack. This only works for a very small set of numbers, so most numbers
will need to be specified manually with parentheses.
- If you write `Bookkeeper's Gambit: vv--` or `mask: vv--` will drop the 3rd and 4th elements of the
stack, as normal. You can use any combination of `v` and `-` like a normal `Bookkeeper's Gambit`.

### Nonpattern iotas

Hex Manager has the ability to include iotas that aren't patterns directly into your spell. This
is particularly helpful to get complex data like vectors and gates included into the spell. Just
like if you did this normally, you would need to add `Consideration` patterns before the nonpattern
iota, depending on how many levels of nesting you use.

Except for lists, all nonpattern iotas start with a hyphen so that you can tell them apart from
normal patterns.

Most types of nonpattern iotas are easy to understand if given an example:
```
- null // The null constant
- garbage // A garbage iota
- true // The true boolean
- false // The false boolean
- 12 // The number 12
- <100,64,-100> // A vector
- "Hello, World" // A string iota, from More Iotas
- entity(61c8f48b-470c-4581-b807-a466b28036c7) // The entity with the provided UUID
- iota_type(hexcasting:entity) // The "Entity" iota type, from Hexal
- entity_type(minecraft:player) // The "Player Type" entity type, from Hexal
```

Some types of nonpattern iotas are not yet listed above, and not all types are available. Please
file an issue on this repository if a type you would like is not available.

### Lists

There are type types of listsh, each using either the `{}` and `[]` brackets.

Both types of brackets can be on the same line as other code without requiring a semicolon to
separate them.

#### Logical Lists - Curly Brackets

The `{}` denote a logical list, the type of list you will probably be using most often. Adding
`{` and `}` to your code will enclose the code they surround in the `Introspection` and
`Retrospection` patterns. This allows you to use them to add an extra level of nesting to your code.

Note that even though `{` basically just adds an `Introspection` iota, it still requires a matching
`}` due to the way it is implemented. If you just want to insert an `Introspection` iota without
requiring a matching `Retrospection` (which is a very rare situation), you can litterally just type
`Introspection` as a pattern iota.

#### Data Lists - Square Brackets

The `[]` denote a data list, which is like if you just inserted a list iota into the spell directly.
You probably need to use `Consideration` to get the spell to work if you use Data Lists.

In general, you won't need Data Lists very frequently.

Data Lists are the only nonpattern iota type which do not need to start with a `hyphen`.

### Preprocessor directives

Lines of code that start with `#` are preprocessor directives, which means that they usually affect
the code or processing environment in some specialized way.

Currently, the following preprocessor directives exist:
- `#alias`
- `#include`
- `#webinclude`

There are a few more preprocessor directives listed here designed for debugging use and are not
intended to be used by the end user.

#### `#alias`

`#alias` lets you provide extra names for frequently used patterns or sets of angles.
The syntax is `#alias name = pattern` or `#alias name = (angles)`. For example:
```
#alias self = get_caster
```
`get_caster` is the shorthand id that refers to `Mind's Reflection`. This alias allows you to type
`self` in place of a pattern, and it will be interpreted as `get_caster`.

Note that currently, aliases affect the entire file, no matter where they are declared. So, an alias
can affect code that is written above it. This may change in the future, so try to declare all your
aliases at the top of the file.

You may wish to declare aliases in a separate file, and then use `#include`, as described below.

#### `#include`

`#include` copies a file into the current file. The path of the file is relative to the file you
compiled with `hexcompile`. If the file you `#include` has `#include` statements of its own, those
are also relative to the original file, not the intermediate file.

For example, if you declared all your aliases in a file called `aliases.hex` in the same folder as
the spell you are writing, then you can type
```
#include aliases.hex
```
to use all your aliases in your current file.

`#include` is not available when using `hexcloud` because there is no way to refer to files in the
local filesystem. You can use `#webinclude` instead in this case.

#### `#webinclude`

`#webinclude` is like `#include`, but it copies a file from the internet rather than from a local
file. Unlike `#include`, it is available whether or not you are using `hexcloud`.

The syntax is `#webinclude "https://url/to/file"`. The quotes were added as a requirement because
otherwise `//` would start a comment. The rules for what counts as a valid url are the same as those
listed above for `hexcloud`.

For example, if you declare all your aliases in a Google Doc, make sure to change the sharing
permissions so that anyone on the internet with the link can view, then use `#webinclude` like:
```
#webinclude "https://docs.google.com/document/d/1266Y8JI6wMIDJncXA18LcQVReV7szAIRT11c9mKcGNQ/edit"
```

Note that Google Docs have special handling, and in most other cases the file is required to be in
plaintext.

Like `hexcloud`. `#webinclude` uses a cache, and it has the same flaw of possibly using an outdated
file without making it obvious that the file is outdated.

## License

Hex Manager is licensed under the MIT License, which means you can do almost whatever you would like
with it. However, if you modify this project to fit your needs, I would love to hear about it.
