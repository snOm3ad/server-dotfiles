#!/bin/bash

print() {
    printf '=%.0s' {1..10}
    printf " $1 "
    printf '=%.0s' {1..10}
    printf '\n'
}

fail() {
    echo -e "[ERROR] $1" && exit -1
}

update() {
    sudo apt update && sudo apt upgrade
}

install() {
    print "INSTALLING $1"
    sudo apt install "$1" || fail "Could not install $1"
}

scripts() {
    curl -o "tmux-dev" -L "https://t.ly/RngGF" || fail "Could not find tmux.dev script"
    sudo chmod +x "tmux-dev" && sudo mv "tmux-dev" "/usr/local/bin/" || fail "Could not move script"
}

clone_private_repo() {
    [ -z "$GHTOKEN" ] && fail "GHTOKEN environment variable not set"
    git clone "https://oauth2:$GHTOKEN@github.com/snOm3ad/dot-nvim-lua" .
}

print "UPDATING PACKAGES"
update || fail "Could not update apt packages."

install "node"
install "fd"
install "ripgrep"
install "fzf"
install "neovim"
install "git-delta"
install "tmux"
install "lua"
install "geckodriver"
install "pyright"

# install tmux-dev
print "INSTALLING TMUX-DEV SCRIPT"
scripts

# install dot files
print "INSTALLING DOT FILES"
mv .bash* .tmux.conf "$HOME/"

print "INSTALLING NEOVIM CONFIG"
mkdir -p "$HOME/.config/nvim" &&
    cd "$HOME/.config/nvim" &&
    clone_private_repo ||
    fail "Could not install dot files"

# finally install rust
print "INSTALLING RUST"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh || fail "Could not install rust!"
