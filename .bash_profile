export PROMPT_DIRTRIM=2
export EDITOR='nvim'
export CARGO_TARGET_DIR='~/.rust-builds/'
export TERM='xterm-256color'



COLOR=39

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
export PS1="[\e[38;5;${COLOR}m\A\e[m] \e[1m\H\e[38;5;${COLOR}m::\e[m\e[1m\u\e[m \e[38;5;${COLOR}m\W\e[m $ "
