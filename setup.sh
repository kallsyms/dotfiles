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
    ln -sfn "${SCRIPTPATH}/$1" "${existing}"
}

# link everything out to homexisting
setup_path "conkyrc" ".conkyrc"
setup_path "ctags.conf" ".ctags"
setup_path "radare2rc" ".radare2rc"
setup_path "tmux.conf" ".tmux.conf"
setup_path "vim" ".vim"
setup_path "zsh/zshrc" ".zshrc"
setup_path "zsh/oh-my-zsh" ".oh-my-zsh"
setup_path "i3" ".config/i3"

# Create zsh overrides file if it doesn't exist
# (for machine-specific customizations)
if [ ! -f "${HOME}/.zshrc-overrides" ]; then
    touch "${HOME}/.zshrc-overrides"
fi

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"

hash ctags 2>/dev/null || echo "You need to install ctags (https://github.com/universal-ctags/ctags)"
hash clang-format 2>/dev/null || echo "You should install clang/clang-format"
