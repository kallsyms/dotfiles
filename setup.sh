#!/bin/sh
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

git -C "${SCRIPTPATH}" submodule update --init --recursive

# link everything out to homedir
ln -s "${SCRIPTPATH}/ctags.conf" "${HOME}/.ctags"
ln -s "${SCRIPTPATH}/radare2rc" "${HOME}/.radare2rc"
ln -s "${SCRIPTPATH}/tmux.conf" "${HOME}/.tmux.conf"
ln -s "${SCRIPTPATH}/vim" "${HOME}/.vim"
ln -s "${SCRIPTPATH}/zsh/oh-my-zsh" "${HOME}/.oh-my-zsh"
ln -s "${SCRIPTPATH}/zsh/zshrc" "${HOME}/.zshrc"

if [ ! -f "${HOME}/.zshrc-overrides" ]; then
    touch "${HOME}/.zshrc-overrides"
fi

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"

hash ctags 2>/dev/null || echo "You need to install ctags (https://github.com/universal-ctags/ctags)"
hash clang-format 2>/dev/null || echo "You should install clang/clang-format"
