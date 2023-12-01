#!/bin/bash

print() {
    printf '=%.0s' {1..15}
    printf " $1 "
    printf '=%.0s' {1..15}
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

neovim() {
    mkdir -p "$HOME/.local/share" && cd "$HOME/.local/share"

    ROOT="https://github.com/neovim/neovim/releases/download/stable"
    RELEASE="nvim-linux64.tar.gz"
    curl -L -O "$ROOT/$RELEASE" && 
        curl -L -O "$ROOT/$RELEASE.sha256sum" || 
        fail "Failed to download files from '$ROOT'"
    
    # verify and untar
    sha256sum -c "$RELEASE.sha256sum" &&
        tar xzvf $RELEASE || 
        fail "Could not untar downloaded file"

    # remove downloaded files
    rm "$RELEASE" "$RELEASE.sha256sum"
    
    # link untar files to bin
    sudo ln -sf "$HOME/.local/share/nvim-linux64/bin/nvim" "/usr/local/bin/nvim" || fail "Could not create symbolic link to nvim binary"
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
    sudo add-apt-repository "deb http://apt.llvm.org/$CODENAME/ llvm-toolchain-$CODENAME main"
}

python3_modules() {
    # check if python3 is installed.
    [ -z "$(which python3)" ] && fail "python3 is required, however it was not found"
    
    # install pip
    install "python3-pip" ||
        fail "Could not install pip3"

    # make .venv dir
    mkdir -p "$HOME/.venvs/" && cd "$HOME/.venvs/"
    
    # get python3 version
    VERSION="$(python3 --version | python3 -c 'import sys; v = [l.split() for l in sys.stdin]; _, v = v[0]; print(".".join(v.split(".")[:-1]))' )"
    [ -n "$VERSION" ] && 
        install "python$VERSION-venv" &&
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
install "pkg-config"
install "cmake"
install "m4" # required by spidermonkey
install "unzip"

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

print "INSTALLING MLIR"
install "libmlir-16-dev" &&
    install "mlir-16-tools"

print "INSTALLING WASM STUFF"
install "libclang-rt-dev-wasm32" &&
    install "libclang-rt-dev-wasm64" &&
    install "libc++-dev-wasm32" &&
    install "libc++abi-16-dev-wasm32" &&
    install "libclang-rt-dev-wasm32" &&
    install "libclang-rt-dev-wasm64"

print "INSTALLING LATEST NEOVIM"
neovim

print "INSTALLING TMUX-DEV SCRIPT"
scripts

print "INSTALLING DOT FILES"
mv .bash* .tmux.conf .gitconfig "$HOME/"

# required for neovim
print "INSTALLING PYTHON MODULES"
python3_modules

print "INSTALLING NEOVIM CONFIG"
mkdir -p "$HOME/.config/nvim" &&
    cd "$HOME/.config/nvim" &&
    clone_private_repo ||
    fail "Could not install dot files"

print "INSTALLING RUST"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh || fail "Could not install rust!"
