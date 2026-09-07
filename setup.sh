#!/bin/bash

# Omarchy dotfiles installer
# Run this right after a fresh Omarchy install (it assumes Omarchy / Arch Linux).

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

print_info()  { echo -e "${GREEN}[INFO]${NC} $1"; }
print_warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Backup and remove existing files/directories/symlinks before linking
backup_and_remove() {
    if [ -L "$1" ]; then
        rm "$1"
        print_info "Removed existing symlink $1"
    elif [ -e "$1" ]; then
        mv "$1" "$1.backup"
        print_info "Backed up $1 to $1.backup"
    fi
}

# Make sure we are on Omarchy (Hyprland-based Arch distribution)
check_omarchy() {
    if [ ! -d /usr/share/omarchy ] || ! command -v omarchy &> /dev/null; then
        print_error "This setup is for Omarchy (https://omarchy.org). Aborting."
        exit 1
    fi
    print_info "Omarchy detected: $(omarchy version 2>/dev/null | head -1)"
}

# Install needed packages (most already ship with Omarchy; --needed is idempotent)
install_packages() {
    print_info "Installing packages..."
    sudo pacman -S --needed --noconfirm \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        neovim \
        tmux \
        alacritty \
        atuin \
        fzf \
        lsd \
        btop \
        lazygit \
        wl-clipboard
    # JetBrainsMono Nerd Font ships with Omarchy (ttf-jetbrains-mono-nerd-basic).
}

# Install Oh My Zsh (unattended; keeps our .zshrc symlink intact afterwards)
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_info "Oh My Zsh already installed"
    fi
}

# Create symlinks for all configs
create_symlinks() {
    print_info "Creating symlinks..."

    DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    mkdir -p ~/.config

    # Neovim
    backup_and_remove ~/.config/nvim
    ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim

    # Tmux (Omarchy bakes the active theme's colors into
    # ~/.local/state/omarchy/current/theme/tmux-theme.conf, which tmux.conf sources)
    backup_and_remove ~/.config/tmux
    ln -s "$DOTFILES_DIR/tmux" ~/.config/tmux

    # Alacritty (link only the file: the rest of ~/.config/alacritty stays
    # Omarchy-managed, and the config imports the active theme automatically)
    mkdir -p ~/.config/alacritty
    backup_and_remove ~/.config/alacritty/alacritty.toml
    ln -s "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml

    # Herdr (link only config.toml; the rest of ~/.config/herdr is runtime state)
    mkdir -p ~/.config/herdr
    backup_and_remove ~/.config/herdr/config.toml
    ln -s "$DOTFILES_DIR/herdr/config.toml" ~/.config/herdr/config.toml

    # Zsh
    backup_and_remove ~/.zshrc
    ln -s "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc

    # Oh My Zsh custom theme
    if [ -d "$HOME/.oh-my-zsh" ]; then
        backup_and_remove ~/.oh-my-zsh/themes/custom_clean.zsh-theme
        ln -s "$DOTFILES_DIR/zsh/custom_clean.zsh-theme" ~/.oh-my-zsh/themes/custom_clean.zsh-theme
    fi

    # Atuin
    backup_and_remove ~/.config/atuin
    ln -s "$DOTFILES_DIR/atuin" ~/.config/atuin

    # Refresh font cache
    print_info "Refreshing font cache..."
    fc-cache -f >/dev/null
}

# Set Omarchy + system defaults
set_defaults() {
    print_info "Setting default applications..."
    omarchy default terminal alacritty
    omarchy default editor nvim

    # Set zsh as the default shell
    if [ "$SHELL" != "$(which zsh)" ]; then
        print_info "Setting zsh as the default login shell..."
        chsh -s "$(which zsh)"
    else
        print_info "zsh is already the default shell"
    fi
}

# Main installation
main() {
    print_info "Starting dotfiles installation (Omarchy)..."

    check_omarchy
    install_packages
    install_oh_my_zsh
    create_symlinks
    set_defaults

    print_info "Dotfiles installation complete!"
    print_warn "Log out and back in (or restart) so zsh becomes your shell."
    print_warn "Neovim plugins will be installed automatically on first start."
}

main
