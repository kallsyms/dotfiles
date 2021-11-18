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
setup_path "vim" ".vim"
setup_path "zsh/zshrc" ".zshrc"
setup_path "zsh/oh-my-zsh" ".oh-my-zsh"
setup_path "flake8" ".config/flake8"

# git hooks
git config --global core.hookspath "${SCRIPTPATH}/git_hooks"
git config --global core.excludesfile "${SCRIPTPATH}/gitignore"

if [[ $(uname -s) == "Linux" ]]; then
    # caps->escape
	echo "setxkbmap -option caps:escape" >> ${HOME}/.xinitrc
    
    if hash apt 2>/dev/null; then
        sudo apt update

        echo "Installing shell and other essentials"
        sudo apt install -y zsh tmux curl vim silversearcher-ag
        echo "chsh:"
        chsh -s $(which zsh)

        echo "Installing build utils"
        sudo apt install -y build-essential autoconf pkg-config

        echo "Installing clang-format"
        sudo apt install -y clang-format

        echo "Installing node"
        curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -
        sudo apt install -y nodejs

        if [ "$(lsb_release -si)" == "Ubuntu" ]; then
            echo "Installing go"
            sudo add-apt-repository ppa:longsleep/golang-backports
            sudo apt update
            sudo apt install -y golang-go

            echo "Installing docker"
            sudo apt install -y apt-transport-https ca-certificates gnupg lsb-release
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
            echo \
              "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io
            sudo usermod -aG docker "${USER}"

            sudo snap install universal-ctags  # for vim tagbar
        else
            echo "You'll need to manually install go, docker, and universal ctags"
        fi
    fi
elif [[ $(uname -s) == "Darwin" ]]; then
    # TODO: karabiner cmd+enter terminal configuration
    # TODO: keyboard rebind in system prefs
    hash brew 2>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo "Installing essentials"
    brew install --cask iterm2 tunnelblick
    brew install tmux vim ag wget
    echo "Installing node"
    brew install node yarn
    echo "Installing go"
    brew install go
    echo "Installing and setting up podman and multipass"
    brew install podman multipass
    podman machine init --cpus 4 --memory 2048
    echo "Installing vim utils"
    brew install universal-ctags
fi
