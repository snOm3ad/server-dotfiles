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
    git clone "https://snom3ad:$GHTOKEN@github.com/snOm3ad/dot-nvim-lua" .
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
    
    # link untarred files to bin
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
    
    # install everything.
    install "python3-full" ||
        fail "Could not install full modules of python"

    # make .venv dir
    mkdir -p "$HOME/.venvs/" && cd "$HOME/.venvs/"
    
    # python3 venv
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

print "ADDING LLVM REPOSITORY"
llvm_setup

print "FETCHING LLVM LATEST STABLE VERSION"
LLVM_VERSION=$(curl -L -O 'https://apt.llvm.org/llvm.sh' | grep -m 1 "CURRENT_LLVM_STABLE" - | awk -F= '{ print $2 }')

print "INSTALLING LLVM-$LLVM_VERSION"
install "lld-$LLVM_VERSION" &&
    install "lldb-$LLVM_VERSION" &&
    install "llvm-$LLVM_VERSION" && 
    install "llvm-$LLVM_VERSION-dev" &&
    install "llvm-$LLVM_VERSION-runtime" &&

print "INSTALLING CLANG SUITE"
install "clang-$LLVM_VERSION" && 
    install "clangd-$LLVM_VERSION" &&
    install "clang-format-$LLVM_VERSION" && 
    install "clang-tidy-$LLVM_VERSION" &&
    install "clang-tools-$LLVM_VERSION" &&
    install "python3-clang-$LLVM_VERSION"

print "INSTALLING C-LIBS"
install "libclang-rt-$LLVM_VERSION-dev" &&
    install "libc++-$LLVM_VERSION-dev" &&
    install "libc++abi-$LLVM_VERSION-dev" &&
    install "libunwind-$LLVM_VERSION-dev"

print "INSTALLING MLIR"
install "libmlir-$LLVM_VERSION-dev" &&
    install "mlir-$LLVM_VERSION-tools"

print "INSTALLING WASM STUFF"
install "libclang-rt-$LLVM_VERSION-dev-wasm32" &&
    install "libclang-rt-$LLVM_VERSION-dev-wasm64" &&
    install "libc++-$LLVM_VERSION-dev-wasm32" &&
    install "libc++abi-$LLVM_VERSION-dev-wasm32" &&

print "INSTALLING LATEST NEOVIM"
neovim

print "INSTALLING TMUX-DEV SCRIPT"
scripts

print "INSTALLING DOT FILES"
mv .bash* "$HOME/"
mv .tmux.conf "$HOME/"
mv .gitconfig "$HOME/"

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
