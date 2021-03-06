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
setup_path "radare2rc" ".radare2rc"
setup_path "tmux.conf" ".tmux.conf"
setup_path "vim" ".vim"
setup_path "zsh/zshrc" ".zshrc"
setup_path "zsh/oh-my-zsh" ".oh-my-zsh"
setup_path "i3" ".config/i3"
setup_path "i3status.conf" ".config/i3status/config"
setup_path "flake8" ".config/flake8"

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"
git config --global core.excludesfile "${SCRIPTPATH}/gitignore"

if hash apt 2>/dev/null; then
    sudo apt update

    echo "Installing shell and other essentials"
    sudo apt install -y zsh tmux curl vim
    echo "chsh:"
    chsh -s $(which zsh)

    echo "Installing build utils"
    sudo apt install -y build-essential autoconf pkg-config

    echo "Installing clang-format"
    sudo apt install -y clang-format

    if [ "$(lsb_release -si)" == "Ubuntu" ]; then
        echo "Installing go"
        sudo add-apt-repository ppa:longsleep/golang-backports
        sudo apt update
        sudo apt install golang-go

        echo "Installing docker"
        sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo \
          "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io
        sudo usermod -aG docker "${USER}"
    else
        echo "You'll need to manually install go and docker"
    fi
else
    hash zsh 2>/dev/null || echo "You need to install zsh"
    hash tmux 2>/dev/null || echo "You need to install tmux"
    hash clang-format 2>/dev/null || echo "You should install clang/clang-format"
fi
