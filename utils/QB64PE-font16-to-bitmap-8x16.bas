' Renders a bitmap font of the _FONT 16 used in QB64 PE
CONST SCALE=1

CONST ROWS=8
CONST COLS=32

CONST CHAR_W=8
CONST CHAR_H=16

CONST GRID_W=9
CONST GRID_H=17

DIM AS LONG w, h, CANVAS

_FONT 16

w& = COLS * GRID_W
h& = ROWS * GRID_H

CANVAS& = _NEWIMAGE(w&, h&, 32)
SCREEN CANVAS&
_DEST CANVAS&
' _DONTBLEND CANVAS&
' _SETALPHA 255, CANVAS&
' CLS

DIM AS INTEGER i, x, y
DIM c AS STRING

FOR i% = 0 TO 255
	x% = (i% MOD COLS) * GRID_W
	y% = (i% \ COLS) * GRID_H
	c$ = CHR$(i%)
	_PRINTMODE _KEEPBACKGROUND
	_PRINTSTRING (x%, y%), c$
NEXT

DIM scaled_canvas AS LONG
scaled_canvas& = _NEWIMAGE(w& * SCALE, h& * SCALE, 32)
_SOURCE CANVAS&
_DEST scaled_canvas&
' _DONTBLEND CANVAS&
' _SETALPHA 255, scaled_canvas&
' CLS
_PUTIMAGE
SCREEN scaled_canvas&
_SAVEIMAGE "DOS-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png", scaled_canvas&, "PNG"

SLEEP

SCREEN 0

CLS
PRINT
PRINT "Saved as DOS-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png"
PRINT
PRINT "Rows and Columns: " + _TRIM$(STR$(ROWS)) + "x" + _TRIM$(STR$(COLS))
PRINT "Character size  : " + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H))
PRINT "Grid size       : " + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H))
PRINT "Scale           : " + _TRIM$(STR$(SCALE))
