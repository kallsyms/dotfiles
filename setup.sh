#!/bin/bash
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

git -C "${SCRIPTPATH}" submodule update --init --recursive

# setup_path path/in/dotfiles path/in/homedir
function setup_path {
    existing="${HOME}/$2"
    if [ -f "${existing}" ] || [ -d "${existing}" ] && [ ! -L "${existing}" ]; then
        echo "Moving existing ${existing} to ${existing}.old"
        mv "${existing}" "${existing}.old"
    fi
    if [ ! -d "$(dirname ${existing})" ]; then
        mkdir -p "$(dirname ${existing})"
    fi
    ln -sfn "${SCRIPTPATH}/$1" "${existing}"
}

# link everything out to home, moving existing files/dirs to {existing}.old
setup_path "conkyrc" ".conkyrc"
setup_path "ctags.conf" ".ctags"
setup_path "radare2rc" ".radare2rc"
setup_path "tmux.conf" ".tmux.conf"
setup_path "vim" ".vim"
setup_path "zsh/zshrc" ".zshrc"
setup_path "zsh/oh-my-zsh" ".oh-my-zsh"
setup_path "i3" ".config/i3"
setup_path "i3status.conf" ".config/i3status/config"
setup_path "flake8" ".config/flake8"

# Create zsh overrides file if it doesn't exist
# (for machine-specific customizations)
if [ ! -f "${HOME}/.zshrc-overrides" ]; then
    touch "${HOME}/.zshrc-overrides"
fi

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"
git config --global core.excludesfile "${SCRIPTPATH}/gitignore"

if hash apt 2>/dev/null; then
    echo "Installing shell"
    sudo apt install zsh
    chsh -s $(which zsh)

    echo "Installing build utils"
    sudo apt install build-essential autoconf pkg-config

    echo "Building and installing ctags"
    pushd /tmp
    git clone https://github.com/universal-ctags/ctags
    cd ctags
    ./autogen.sh
    ./configure
    make -j $(nproc)
    sudo make install
    popd

    rm -rf /tmp/ctags

    echo "Installing clang-format"
    sudo apt install clang-format
else
    hash ctags 2>/dev/null || echo "You need to install ctags (https://github.com/universal-ctags/ctags)"
    hash zsh 2>/dev/null || echo "You need to install zsh"
    hash clang-format 2>/dev/null || echo "You should install clang/clang-format"
fi
