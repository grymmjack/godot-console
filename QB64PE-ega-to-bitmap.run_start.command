cd "$(dirname "$0")"
./"QB64PE-ega-to-bitmap.run" &
osascript -e 'tell application "Terminal" to close (every window whose name contains "QB64PE-ega-to-bitmap.run_start.command")' &
osascript -e 'if (count the windows of application "Terminal") is 0 then tell application "Terminal" to quit' &
exit
