#!/bin/bash

# Function to backup and remove existing files/directories
backup_and_remove() {
    if [ -e "$1" ]; then
        mv "$1" "$1.backup"
        echo "Backed up $1 to $1.backup"
    fi
}

# Get current directory (where dotfiles are)
DOTFILES_DIR=$(pwd)

# Create necessary directories
mkdir -p ~/.config

# Backup existing files/directories and create symlinks
backup_and_remove ~/.config/nvim
ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim

backup_and_remove ~/.config/alacritty.toml
ln -s "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty.toml

backup_and_remove ~/.zshrc
ln -s "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc

backup_and_remove ~/.tmux
ln -s "$DOTFILES_DIR/tmux/.tmux" ~/.tmux

backup_and_remove ~/.tmux.conf
ln -s "$DOTFILES_DIR/tmux/.tmux.conf" ~/.tmux.conf

backup_and_remove ~/.fonts
ln -s "$DOTFILES_DIR/fonts/.fonts" ~/.fonts

echo "Dotfiles installation complete!"
