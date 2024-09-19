class_name AnsiParser
extends TextConsole

const ESC := 27
const CSI := "%c[" % ESC

# CURSOR
const CURSOR_HOME         := "H"
const CURSOR_MOVE1        := "H"
const CURSOR_MOVE2        := "f"
const CURSOR_UP           := "A"
const CURSOR_DOWN         := "B"
const CURSOR_RIGHT        := "C"
const CURSOR_LEFT         := "D"
const CURSOR_COL0_DOWN    := "E"
const CURSOR_COL0_UP      := "F"
const CURSOR_MOVE_COL     := "G"
const CURSOR_SCROLL_UP    := "M"
const CURSOR_SAVE_POS     := "s"
const CURSOR_REST_POS     := "u"

# ERASE
const ERASE_CURSOR_EOS    := "0J"
const ERASE_CURSOR_BOS    := "1J"
const ERASE_SCREEN        := "2J"
const ERASE_CRSR_EOL      := "0K"
const ERASE_CRSR_BOL      := "1K"
const ERASE_LINE          := "2K"

# GRAPHICS MODES
const GFX_RESET           := "0m"
const GFX_BOLD            := "1m"
const GFX_DIMMED          := "2m"
const GFX_ITALIC          := "3m"
const GFX_UNDERLINE       := "4m"
const GFX_BLINKING        := "5m"
const GFX_INVERSE         := "7m"
const GFX_HIDDEN          := "8m"
const GFX_STRIKEOUT       := "9m"

# FOREGROUND COLORS
const COLOR_RESET         := "0m"
const COLOR_FG_DEFAULT    := "39m"
const COLOR_FG_BLACK      := "0;30"
const COLOR_FG_BLUE       := "0;34"
const COLOR_FG_GREEN      := "0;32"
const COLOR_FG_CYAN       := "0;36"
const COLOR_FG_RED        := "0;31"
const COLOR_FG_MAGENTA    := "0;35"
const COLOR_FG_BROWN      := "0;33"
const COLOR_FG_WHITE      := "0;37"
const COLOR_FG_GRAY       := "1;30"
const COLOR_FG_BR_BLUE    := "1;34"
const COLOR_FG_BR_GREEN   := "1;32"
const COLOR_FG_BR_CYAN    := "1;36"
const COLOR_FG_BR_RED     := "1;31"
const COLOR_FG_BR_MAGENTA := "1;35"
const COLOR_FG_BR_BROWN   := "1;33"
const COLOR_FG_BR_WHITE   := "1;37"

# BACKGROUND COLORS
const COLOR_BG_BLACK      := "40"
const COLOR_BG_BLUE       := "44"
const COLOR_BG_GREEN      := "42"
const COLOR_BG_CYAN       := "46"
const COLOR_BG_RED        := "41"
const COLOR_BG_MAGENTA    := "45"
const COLOR_BG_BROWN      := "43"
const COLOR_BG_WHITE      := "47"
const COLOR_BG_GRAY       := "5;40"
const COLOR_BG_BR_BLUE    := "5;44"
const COLOR_BG_BR_GREEN   := "5;42"
const COLOR_BG_BR_CYAN    := "5;46"
const COLOR_BG_BR_RED     := "5;41"
const COLOR_BG_BR_MAGENTA := "5;45"
const COLOR_BG_BR_BROWN   := "5;43"
const COLOR_BG_BR_WHITE   := "5;47"

func _ready():
	pass # Replace with function body.
