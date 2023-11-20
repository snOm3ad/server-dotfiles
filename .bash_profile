# After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable.
export PROMPT_DIRTRIM=2
export EDITOR='nvim'
export CARGO_TARGET_DIR="${HOME}/.rust-builds/"

# Source .bashrc from here
[[ -f "$HOME/.bashrc" ]] && . "$HOME/.bashrc"


# NOTE: this will only work in bash!
# \e[x;ym \e[m
# \e[   starts color scheme
# x;y   color pair to use.
# \e[m  stops a color scheme
#
# ===========================
# xterm-256color works like so:
#
# 38;5; sequence start for the foreground
# 48;5; sequence start for the background
case "$TERM" in
    *256color | alacritty) export PS1="[\[\e[38;5;39m\]\t\[\e[0m\]] \[\e[1m\]\h \[\e[0;38;5;39m\]\W \[\e[0m\]\$ " ;;
    *) export PS1="[\t] \[\e[1m\]\h \[\e[0m\]\W \$ " ;;
esac
