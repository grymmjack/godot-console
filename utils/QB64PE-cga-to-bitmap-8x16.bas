' Renders an EGA Palette to a bitmap
CONST SCALE=1

CONST ROWS=1
CONST COLS=16

CONST CHAR_W=8
CONST CHAR_H=16

CONST GRID_W=9
CONST GRID_H=17

DIM AS LONG w, h, CANVAS


'EGA palette is easy to use in hex color value format
DIM EGA(0 TO 15) AS _UNSIGNED LONG
EGA~&(0)  = &HFF000000
EGA~&(1)  = &HFFAA0000
EGA~&(2)  = &HFF00AA00
EGA~&(3)  = &HFFAA5500
EGA~&(4)  = &HFF0000AA
EGA~&(5)  = &HFFAA00AA
EGA~&(6)  = &HFF00AAAA
EGA~&(7)  = &HFFAAAAAA
EGA~&(8)  = &HFF555555
EGA~&(9)  = &HFFFF5555
EGA~&(10) = &HFF55FF55
EGA~&(11) = &HFFFFFF55
EGA~&(12) = &HFF5555FF
EGA~&(13) = &HFFFF55FF
EGA~&(14) = &HFF55FFFF
EGA~&(15) = &HFFFFFFFF


w& = COLS * GRID_W
h& = ROWS * GRID_H

CANVAS& = _NEWIMAGE(w&, h&, 32)
SCREEN CANVAS&
_FONT 16
_DEST CANVAS&
_DONTBLEND CANVAS&
_SETALPHA 255, CANVAS&
CLS

DIM AS INTEGER i, x, y
DIM c AS STRING

FOR i% = 0 TO 15
	x% = (i% MOD COLS) * GRID_W
	y% = (i% \ COLS) * GRID_H
	LINE (x%, y%)-STEP(GRID_W, GRID_H), EGA~&(i%), BF
NEXT

DIM scaled_canvas AS LONG
scaled_canvas& = _NEWIMAGE(w& * SCALE, h& * SCALE, 32)
_SOURCE CANVAS&
_DEST scaled_canvas&
_PUTIMAGE
SCREEN scaled_canvas&
_SAVEIMAGE "CGA-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png", scaled_canvas&, "PNG"

SLEEP

SCREEN 0

CLS
PRINT
PRINT "Saved as CGA-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png"
PRINT
PRINT "Rows and Columns: " + _TRIM$(STR$(ROWS)) + "x" + _TRIM$(STR$(COLS))
PRINT "Character size  : " + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H))
PRINT "Grid size       : " + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H))
PRINT "Scale           : " + _TRIM$(STR$(SCALE))
