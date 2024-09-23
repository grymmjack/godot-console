' Renders an EGA Palette to a bitmap
CONST SCALE=1

CONST ROWS=1
CONST COLS=16

CONST CHAR_W=8
CONST CHAR_H=16

CONST GRID_W=9
CONST GRID_H=17

DIM AS LONG w, h, CANVAS


'CGA palette is easy to use in hex color value format
DIM CGA(0 TO 15) AS _UNSIGNED LONG
CGA~&(0)  = &HFF000000
CGA~&(1)  = &HFFAA0000
CGA~&(2)  = &HFF00AA00
CGA~&(3)  = &HFFAA5500
CGA~&(4)  = &HFF0000AA
CGA~&(5)  = &HFFAA00AA
CGA~&(6)  = &HFF00AAAA
CGA~&(7)  = &HFFAAAAAA
CGA~&(8)  = &HFF555555
CGA~&(9)  = &HFFFF5555
CGA~&(10) = &HFF55FF55
CGA~&(11) = &HFFFFFF55
CGA~&(12) = &HFF5555FF
CGA~&(13) = &HFFFF55FF
CGA~&(14) = &HFF55FFFF
CGA~&(15) = &HFFFFFFFF


w& = COLS * GRID_W * 2
h& = ROWS * GRID_H

CANVAS& = _NEWIMAGE(w&, h&, 32)
SCREEN CANVAS&
_FONT 16
_DEST CANVAS&

DIM AS INTEGER i, x, y
DIM c AS STRING

FOR i% = 0 TO 15
	x% = (i% MOD COLS) * (GRID_W * 2)
	y% = (i% \ COLS) * GRID_H
	LINE (x%, y%)-STEP(CHAR_W, GRID_H), CGA~&(i%), BF
NEXT

DIM scaled_canvas AS LONG
scaled_canvas& = _NEWIMAGE(w& * SCALE, h& * SCALE, 32)
_SOURCE CANVAS&
_DEST scaled_canvas&
_PUTIMAGE
SCREEN scaled_canvas&
_SAVEIMAGE "CGA-BLINKING-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png", scaled_canvas&, "PNG"

SLEEP

SCREEN 0

CLS
PRINT
PRINT "Saved as CGA-BLINKING-" + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H)) + "-" + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H)) + "-SCALED-" + _TRIM$(STR$(SCALE)) + "x.png"
PRINT
PRINT "Rows and Columns: " + _TRIM$(STR$(ROWS)) + "x" + _TRIM$(STR$(COLS))
PRINT "Character size  : " + _TRIM$(STR$(CHAR_W)) + "x" + _TRIM$(STR$(CHAR_H))
PRINT "Grid size       : " + _TRIM$(STR$(GRID_W)) + "x" + _TRIM$(STR$(GRID_H))
PRINT "Scale           : " + _TRIM$(STR$(SCALE))
