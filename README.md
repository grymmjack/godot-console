# Working CGA Godot Text Mode 16 color DOS console

## Supports multiple screen modes:
- 8x8 (50 row mode in DOS)
- 8x16 (80x25 standard VGA font)
- 9x16 DOS 9px font width - see: https://16colo.rs/ansiflags.php#letterspacing

## More goodies
- Greatly expanded the exported parameters
- Added scale factor
- Added support for ANSIFlags - see: https://www.acid.org/info/sauce/sauce.htm#ANSiFlags
- Changing screen mode and scale in Editor updates in real time
- Can now load ANSIs!

## TO DO
- Blinking :D
- Cursors
- Input
- Baud Rate Emulation
- Scrolling / Scrollback
- PIPEPRINT! port [from my QB64 library](https://github.com/grymmjack/QB64_GJ_LIB/tree/main/PIPEPRINT)
- ANSI Music?
- Possibly making this an @tool so it can load an ANSI into the editor in 2D mode GUI
  
## Example ANSIs
![image](https://github.com/user-attachments/assets/8fc95678-4b48-4381-95fc-62601e3c90ba)

## Example output
![image](https://github.com/user-attachments/assets/0206398b-f128-4126-b79e-6282e94e4634)
[Web export](https://beta.grymmjack.com/godot-console/) version here (I will update this as needed)

## 9px width mode
![image](https://github.com/user-attachments/assets/100aaba8-c9f1-4dea-862f-747b5003662d)

## 8px width mode
![image](https://github.com/user-attachments/assets/eb57faea-8cc0-42a3-843d-7a73ed1f1282)

## 8x8 font mode
![image](https://github.com/user-attachments/assets/0f8742bc-33a9-4c2a-9025-89df66e9a985)

The node tree is uncluttered:
![image](https://github.com/user-attachments/assets/302db284-6091-4423-a505-7bd8e2df0511)
- `SCREEN` = TextConsole node
- `BG` = TileMapLayer named BG, which uses the [solid color tile map](assets/CGAColors.tres)
- `FG` = TileMapLayer named FG, which uses the [font tile map](assets/DOSFont-CGA.tres) and alternative tiles for each color in the palette.

## How to use
1. Load `main.tscn`
2. Adjust properties of the SCREEN node to suit in the property inspector
3. In `scripts/main.gd` make sure it is TextScreen and extends `AnsiParser` that's it.

### How the hell does this work?
> The trick here is that there are 2 tilemap layers. A background one (BG) for background colors under the foreground one (FG). 
- Since CGA has 16 background colors we have 16 background tiles in the BG tilemap. 
- Since CGA has 16 foreground colors, we have 1 DOS Font 8x16 that has alternative tiles for every tile to match every color in the CGA palette. (Thanks to [SelinaDev](https://github.com/SelinaDev/) for the help and idea to use alternative tiles instead of duplicate tilemap atlasses!)

> Then we just use `set_cell` and some little translation funcs to do stuff. This gets us a x, y grid just like `SCREEN 0` in basic, etc. It's not REAL console mode, it's a graphical version. Godot doesn't have the ability to do CLI stuff AFAIK.

### BASIC-like API (WIP)

- `echo` = `print`
- `cecho` = `print` in colors (specify fg/bg)
- `locate` = `locate` :D
- `cls` = `cls`
- `load_ansi_file(pathname)` = load and display an ANSI file
- etc.

See: [scripts/text_console.gd](scripts/text_console.gd) for basics, `consts`, `enums`, etc.

### Example use in `scripts/main.gd`:
```gdscript
extends TextConsole

func _ready() -> void:
	color(CGA.BRIGHT_WHITE, CGA.BLUE)
	cls()
	print_ruler()
	locate(10, 2)
	cecho("    Hello, World!    ", 14, 4)
	# will load ansi file from disk at current cursor position
	load_ansi_file("res://your_ansi.ans")

# print a little ruler
func print_ruler() -> void:
	for y in range(height):
		for x in range(width):
			if y == 0:
				if x % 10 == 0:
					locate(x, y)
					echo(str(x))
		locate(0, y)
		echo(str(y))
```

Thanks again to Hueson for the idea to use TileMaps in general, and Selina for the guidance on best way to do it! ❤️
