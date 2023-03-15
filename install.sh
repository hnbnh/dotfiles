#!/bin/bash

set -e

function have {
    command -v "$1" &> /dev/null
}

function install_dots {
    CFG_DIR="$HOME/dotfiles/config"
    DEST_DIR="$HOME/.config"

    mkdir -p $DEST_DIR

    for dir in "$CFG_DIR"/*/; do
        ln -sfnv $dir $DEST_DIR
    done

    ln -sfnv "$CFG_DIR/zsh/.zshrc" "$HOME/.zshrc"
    ln -sfnv "$CFG_DIR/zsh/.zimrc" "$HOME/.zimrc"
    ln -sfnv "$CFG_DIR/git/.gitconfig" "$HOME/.gitconfig"
    ln -sfnv "$CFG_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    ln -sfnv "$CFG_DIR/betterlockscreen/betterlockscreenrc" "$HOME/.config/betterlockscreenrc"
    ln -sfnv "$CFG_DIR/ripgrep/.ripgreprc" "$HOME/.ripgreprc"
    ln -sfnv "$CFG_DIR/yt-dlp/yt-dlp.conf" "$HOME/yt-dlp.conf"
}

function setup_linux {
    # Install ansible & plugins
    have ansible || pip install --user ansible

    [ -d ~/.ansible/collections/ansible_collections/community ] || \
        ansible-galaxy collection install community.general

    # Run Ansible
    ansible-playbook -i ./ansible/hosts ./ansible/linux.yml --ask-become-pass
}

function setup_macos {
    # Install nix
    if ! have "nix-build"; then
        curl -L https://nixos.org/nix/install | sh
        # Workaround for https://github.com/LnL7/nix-darwin/issues/149
        sudo rm /etc/nix/nix.conf
    fi

    # Install homebrew
    if ! have brew; then
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o /tmp/brew-install.sh
        NONINTERACTIVE=1 bash /tmp/brew-install.sh
    fi

    # Set up nix-darwin
    cd nix-darwin
    /nix/var/nix/profiles/default/bin/nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    yes | ./result/bin/darwin-installer

    /nix/var/nix/profiles/default/bin/nix --experimental-features 'nix-command flakes' build ./\#darwinConfigurations.$(hostname -s).system
}

function main() {
    install_dots

    if [ "$(uname)" == "Darwin" ]; then
        setup_macos
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        setup_linux
    else
        echo "Unsupported OS"
        exit 1
    fi
}

main
