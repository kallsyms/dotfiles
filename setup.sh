#!/bin/bash
set -ex

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
setup_path "tmux.conf" ".tmux.conf"
setup_path "nvim" ".config/nvim"
setup_path "zsh/zshrc" ".zshrc"
setup_path "zsh/oh-my-zsh" ".oh-my-zsh"
setup_path "i3" ".config/i3"
setup_path "i3status.conf" ".config/i3status/config"
setup_path "flake8" ".config/flake8"
setup_path "agignore" ".ignore"

git config --global user.name "Nick Gregory"
git config --global user.email computerfreak97@gmail.com

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"
git config --global core.excludesfile "${SCRIPTPATH}/gitignore"

git config --global init.defaultBranch main

if [[ $(uname -s) == "Linux" ]]; then
    # caps->escape
    echo "setxkbmap -option caps:escape" >> ${HOME}/.xinitrc
    
    if hash apt 2>/dev/null; then
        sudo apt update

        echo "Installing shell and other essentials"
        sudo apt install -y zsh tmux curl neovim silversearcher-ag
        sudo chsh -s $(which zsh) "${USER}"

        echo "Installing build utils"
        sudo apt install -y clang build-essential autoconf pkg-config cmake gdb

        echo "Installing clang-format"
        sudo apt install -y clang-format

        echo "Installing python stuff"
        sudo apt install -y python3-pip ipython3

        echo "Installing QEMU"
        sudo apt install -y qemu-system qemu-user

        echo "Installing node"
        sudo apt-get install -y ca-certificates curl gnupg
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
        echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list
        sudo apt update
        sudo apt install -y nodejs

        if [ "$(lsb_release -si)" == "Ubuntu" ]; then
            echo "Installing go"
            sudo add-apt-repository -y ppa:longsleep/golang-backports
            sudo apt update
            sudo apt install -y golang-go

            echo "Installing rust"
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

            echo "Installing docker"
            sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
            sudo usermod -aG docker "${USER}"

            sudo snap install universal-ctags  # for vim tagbar
        else
            echo "You'll need to manually install go, rust, docker, and universal ctags"
        fi
    fi
elif [[ $(uname -s) == "Darwin" ]]; then
    # TODO: karabiner cmd+enter terminal configuration
    # TODO: keyboard rebind in system prefs
    hash brew 2>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Installing essentials"
    brew install --cask iterm2 tunnelblick
    brew install tmux neovim ag wget
    echo "Installing node"
    brew install node yarn
    echo "Installing go"
    brew install go
    echo "Installing rust"
    brew install rustup-init
    rustup-init -y
    echo "Installing and setting up multipass"
    brew install podman multipass
    #podman machine init --cpus 4 --memory 2048
    echo "Installing vim utils"
    brew install universal-ctags
fi

# Bootstrap nvim plugins
nvim -c 'PackerSync' -c 'CocUpdate'
