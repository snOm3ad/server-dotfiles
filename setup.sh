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

neovim_beta() {
    print "INSTALLING $1"
    sudo snap install --beta "$1" --classic || fail "Could not install $1"
}

llvm_setup() {
    # get ubuntu codename
    CODENAME="$(lsb_release -c | tail | awk '{ print $2 }' )"
    [ -z "$CODENAME" ] && fail "Could not fetch codename for this distro"

    # get the gpg key
    curl -O -L 'https://apt.llvm.org/llvm-snapshot.gpg.key' && 
        sudo apt-key add 'llvm-snapshot.gpg.key' && 
        rm 'llvm-snapshot.gpg.key' ||
        fail "Could not add gpg key"

    # add repository
    add-apt-repository "deb http://apt.llvm.org/$CODENAME/ llvm-toolchain-$CODENAME main"
}

python3_venv() {
    # check if python3 is installed.
    [ -z "$(which python3)" ] && fail "python3 is required, however it was not found"
    # make .venv dir
    mkdir -p "$HOME/.venvs/" && cd "$HOME/.venvs/"
    
    # get python3 version
    VERSION="$(python3 --version | python3 -c 'import sys; v = [line.split() for line in sys.stdin]; _, v = v[0]; print(".".join(v.split(".")[:-1]))' )"
    [ -n "$VERSION" ] && 
        install "python$PYTHON_VERSION-venv" &&
        python3 -m venv neovim || 
        fail "Could not create python3 virtual environment"
}

print "INSTALLING MISC PACKAGES"
install "nodejs"
install "fd-find"
install "ripgrep"
install "fzf"
install "git-delta"
install "tmux"
install "snapd"
install "ppa-purge"

print "INSTALLING LLVM"
llvm_setup && 
    install "lld" &&
    install "lldb" &&
    install "llvm" && 
    install "llvm-dev" &&
    install "llvm-runtime" &&

print "INSTALLING CLANG SUITE"
install "clang" && 
    install "clangd" &&
    install "clang-format" && 
    install "clang-tidy" &&
    install "clang-tools" &&
    install "python3-clang"

print "INSTALLING C-LIBS"
install "libclang-rt-dev" &&
    install "libc++-dev" &&
    install "libc++abi-dev" &&
    install "libunwind-dev"

print "INSTALLING WASM STUFF"
install "libclang-rt-dev-wasm32" &&
    install "libclang-rt-dev-wasm64" &&
    install "libc++-dev-wasm32" &&
    install "libc++abi-dev-wasm32" &&
    install "libclang-rt-dev-wasm32" &&
    install "libclang-rt-dev-wasm64"

neovim_beta "neovim"

print "INSTALLING TMUX-DEV SCRIPT"
scripts

print "INSTALLING DOT FILES"
mv .bash* .tmux.conf "$HOME/"

# required for neovim
print "INSTALLING PYTHON VENV"
python3_venv

print "INSTALLING NEOVIM CONFIG"
mkdir -p "$HOME/.config/nvim" &&
    cd "$HOME/.config/nvim" &&
    clone_private_repo ||
    fail "Could not install dot files"

print "INSTALLING RUST"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh || fail "Could not install rust!"