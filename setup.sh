#!/bin/bash

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to backup and remove existing files/directories/symlinks
backup_and_remove() {
    if [ -L "$1" ]; then
        rm "$1"
        print_info "Removed existing symlink $1"
    elif [ -e "$1" ]; then
        mv "$1" "$1.backup"
        print_info "Backed up $1 to $1.backup"
    fi
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS=$ID
        else
            OS="unknown"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    else
        OS="unknown"
    fi
    print_info "Detected OS: $OS"
}

# Install Homebrew if not present
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add brew to PATH for Linux
        if [[ "$OS" == "linux-gnu"* ]] || [[ "$OS" == "ubuntu"* ]] || [[ "$OS" == "debian"* ]]; then
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    else
        print_info "Homebrew already installed"
    fi
}

# Install essential tools
install_tools() {
    print_info "Installing essential tools..."
    
    # Install lsd (modern ls replacement)
    if ! command -v lsd &> /dev/null; then
        print_info "Installing lsd..."
        brew install lsd
    else
        print_info "lsd already installed"
    fi
    
    # Install fzf (fuzzy finder)
    if ! command -v fzf &> /dev/null; then
        print_info "Installing fzf..."
        brew install fzf
    else
        print_info "fzf already installed"
    fi
    
    # Install atuin (shell history)
    if ! command -v atuin &> /dev/null; then
        print_info "Installing atuin..."
        brew install atuin
    else
        print_info "atuin already installed"
    fi

    # Install xclip for clipboard support
    if ! command -v xclip &> /dev/null; then
        print_info "Installing xclip for clipboard support..."
        if [[ "$OS" == "ubuntu"* ]] || [[ "$OS" == "debian"* ]]; then
            sudo apt-get install -y xclip
        elif [[ "$OS" == "fedora"* ]]; then
            sudo dnf install -y xclip
        elif [[ "$OS" == "arch"* ]]; then
            sudo pacman -S --noconfirm xclip
        fi
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        print_info "Oh My Zsh already installed"
    fi
}

# Install fzf-tab plugin for Oh My Zsh
install_fzf_tab() {
    FZF_TAB_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fzf-tab"
    if [ ! -d "$FZF_TAB_DIR" ]; then
        print_info "Installing fzf-tab plugin..."
        git clone https://github.com/Aloxaf/fzf-tab "$FZF_TAB_DIR"
    else
        print_info "fzf-tab plugin already installed"
    fi
}

# Create symlinks
create_symlinks() {
    print_info "Creating symlinks..."
    
    DOTFILES_DIR=$(pwd)
    
    # Create necessary directories
    mkdir -p ~/.config
    
    # Neovim
    backup_and_remove ~/.config/nvim
    ln -s "$DOTFILES_DIR/nvim" ~/.config/nvim
    
    # Alacritty
    backup_and_remove ~/.config/alacritty.toml
    ln -s "$DOTFILES_DIR/alacritty/alacritty.toml" ~/.config/alacritty.toml
    
    # Zsh
    backup_and_remove ~/.zshrc
    ln -s "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
    
    # Tmux
    backup_and_remove ~/.config/tmux
    ln -s "$DOTFILES_DIR/tmux" ~/.config/tmux
    
    # Fonts
    backup_and_remove ~/.fonts
    ln -s "$DOTFILES_DIR/fonts/.fonts" ~/.fonts

    # Atuin
    backup_and_remove ~/.config/atuin
    ln -s "$DOTFILES_DIR/atuin" ~/.config/atuin
    
    # Oh My Zsh custom theme
    if [ -d "$HOME/.oh-my-zsh" ]; then
        backup_and_remove ~/.oh-my-zsh/themes/custom_clean.zsh-theme
        ln -s "$DOTFILES_DIR/zsh/custom_clean.zsh-theme" ~/.oh-my-zsh/themes/custom_clean.zsh-theme
    fi
    
    # Refresh font cache
    if command -v fc-cache &> /dev/null; then
        print_info "Refreshing font cache..."
        fc-cache -fv
    fi
}

# Main installation
main() {
    print_info "Starting dotfiles installation..."
    
    detect_os
    install_homebrew
    install_tools
    install_oh_my_zsh
    install_fzf_tab
    create_symlinks
    
    print_info "Dotfiles installation complete!"
    print_warn "Please restart your terminal or run: source ~/.zshrc"
}

main
