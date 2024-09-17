<del>WIP Godot Text Mode console using RichTextLabel, and bitmap font</del>

# Working CGA Godot Text Mode 16 color DOS console

![image](https://github.com/user-attachments/assets/0206398b-f128-4126-b79e-6282e94e4634)

Load TEXTMODE.tscn

Adjust width and height of the TEXTMODE to suit.

Code is pretty easy.

The trick here is that there are 2 tilemap layers.

A background one (BG) for background colors under the foreground one (FG).

I made some BASIC-like API for this so far, but will be adding ANSI support, too.

`echo` = `print`
`cecho` = `print` in colors (specify fg/bg)
`locate` = `locate` :D
`cls` = `cls`

etc.


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
