' Renders a bitmap font of the _FONT 16 used in QB64 PE
$CONSOLE
CONST SCALE=1

CONST ROWS=8
CONST COLS=32

CONST CHAR_W=9
CONST CHAR_H=16

CONST GRID_W=9
CONST GRID_H=17

DIM AS LONG w, h, CANVAS

_FONT 16

w& = COLS * GRID_W * 2
h& = ROWS * GRID_H

CANVAS& = _NEWIMAGE(w&, h&, 32)
SCREEN CANVAS&
_DEST CANVAS&

DIM AS INTEGER i, x, y
DIM c AS STRING
DIM AS LONG color_check, color_white
color_white& = _RGB32(255, 255, 255)
COLOR color_white&, 0

FOR i% = 0 TO 255
	x% = (i% MOD COLS) * (GRID_W * 2)
	y% = (i% \ COLS) * GRID_H
	c$ = CHR$(i%)
	_PRINTMODE _KEEPBACKGROUND
	_PRINTSTRING (x%, y%), c$
	' Copy 8th pixel in cell to the 9th pixel all the way down (for DOS compatibility)
	' See: https://16colo.rs/ansiflags.php#letterspacing
	IF i% >= 192 AND i% <= 223 THEN
		FOR j% = 0 TO CHAR_H
			_ECHO "Checking X: " + _TRIM$(STR$(x% + 7)) + ", Y: " + _TRIM$(STR$(y% + j%))
			color_check& = POINT(x% + 7, y% + j%)
			_ECHO "Color: " + _TRIM$(STR$(color_check&))
			IF color_check& = color_white& THEN
				_ECHO "has 8th pixel"
				PSET (x% + 8, y% + j%), color_white&
			END IF
		NEXT j%
	END IF
NEXT

DIM scaled_canvas AS LONG
scaled_canvas& = _NEWIMAGE(w& * SCALE, h& * SCALE, 32)
_SOURCE CANVAS&
_DEST scaled_canvas&
_PUTIMAGE
SCREEN scaled_canvas&
_SAVEIMAGE "DOS-BLINKING-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png", scaled_canvas&, "PNG"

SLEEP

SCREEN 0

CLS
PRINT
PRINT "Saved as DOS-BLINKING-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png"
PRINT
PRINT "Rows and Columns: " + _TRIM$(STR$(ROWS)) + "x" + _TRIM$(STR$(COLS))
PRINT "Character size  : " + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H))
PRINT "Grid size       : " + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H))
PRINT "Scale           : " + _TRIM$(STR$(SCALE))
