#!/bin/sh
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

git -C "${SCRIPTPATH}" submodule update --init --recursive

# link everything out to homedir
ln -sf "${SCRIPTPATH}/ctags.conf" "${HOME}/.ctags"
ln -sf "${SCRIPTPATH}/radare2rc" "${HOME}/.radare2rc"
ln -sf "${SCRIPTPATH}/tmux.conf" "${HOME}/.tmux.conf"
ln -sf "${SCRIPTPATH}/vim" "${HOME}/.vim"
ln -sf "${SCRIPTPATH}/zsh/oh-my-zsh" "${HOME}/.oh-my-zsh"
ln -sf "${SCRIPTPATH}/zsh/zshrc" "${HOME}/.zshrc"

if [ ! -f "${HOME}/.zshrc-overrides" ]; then
    touch "${HOME}/.zshrc-overrides"
fi

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"

hash ctags 2>/dev/null || echo "You need to install ctags (https://github.com/universal-ctags/ctags)"
hash clang-format 2>/dev/null || echo "You should install clang/clang-format"
