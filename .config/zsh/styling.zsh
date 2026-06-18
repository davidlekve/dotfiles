#autoload -Uz colors && colors
PROMPT='%F{240}%D{%H:%M:%S}%f %F{blue}%~%f %F{green}$(git rev-parse --abbrev-ref HEAD 2>/dev/null | sed "s/^/(/; s/$/)/")%f$ '
