# After reading that file, it looks for ~/.bash_profile, ~/.bash_login, and ~/.profile, in that order, and reads and executes commands from the first one that exists and is readable.
export PROMPT_DIRTRIM=2
export EDITOR='nvim'
export CARGO_TARGET_DIR="${HOME}/.rust-builds/"
export TERM='xterm-256color'

whichdev() {
    { fd . -t d --max-depth=4 --base-directory="$HOME/dev/"; echo "dev/"; } | sort | fzf 
}

# Functions
gotodir () {
    TARGETDIR="$(whichdev)"
    case $TARGETDIR in
        dev/) cd "$HOME/dev/" ;;
        "") ;;
        *) cd "$HOME/dev/$TARGETDIR" ;;
    esac
    cd $(fd . ~/dev/rust/ -t d --max-depth=3 | fzf)
}


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
    *256color | alacritty) export PS1="PS1='[\[\e[38;5;39m\]\t\[\e[0m\]] \[\e[1m\]\h \[\e[0;38;5;38m\]\W \[\e[0m\]\$ '" ;;
    *) export PS1="[\t] \[\e[1m\]\h \[\e[0m\]\W \$ " ;;
esac
