<del>WIP Godot Text Mode console using RichTextLabel, and bitmap font</del>

# Working CGA Godot Text Mode 16 color DOS console

![image](https://github.com/user-attachments/assets/0206398b-f128-4126-b79e-6282e94e4634)

The node tree is uncluttered:
![image](https://github.com/user-attachments/assets/47736fce-2be8-4a01-abcc-e58897c4a3a1)


Load TEXTMODE.tscn

Adjust width and height of the TEXTMODE to suit.

Code is pretty easy.

The trick here is that there are 2 tilemap layers.

A background one (BG) for background colors under the foreground one (FG). Since CGA has 16 background colors we have 16 background tiles in the BG tilemap. Since CGA has 16 foreground colors, we have 16 different atlasses that are modulated to use the CGA colors according to their DOS color index... Then we just use `set_cell` and some little translation funcs to do stuff. This gets us a x, y grid just like `SCREEN 0` in basic, etc. It's not REAL console mode, it's a graphical version. Godot doesn't have the ability to do CLI stuff AFAIK.

I made some BASIC-like API for this so far, but will be adding ANSI support, too.

- `echo` = `print`
- `cecho` = `print` in colors (specify fg/bg)
- `locate` = `locate` :D
- `cls` = `cls`

etc.

See: [textmode.gd](textmode.gd) for basics, and [_global.gd](_global.gd) for the singleton that gets loaded with a bunch of the `consts`, `enums`, etc.

example use:
```gdscript
func _ready() -> void:
	color(G.CGA.BRIGHT_WHITE, G.CGA.BLUE)
	cls()
	print_ruler()
	locate(10, 2)
	cecho("    Hello, World!    ", 14, 4)

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
