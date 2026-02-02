#!/bin/bash

# Leer el tema actual (si no existe, usar dark por deecto)
CURRENT_THEME=$(cat ~/.config/theme-mode 2>/dev/null || echo "dark")

# Toggle entre light y dark
if [ "$CURRENT_THEME" = "dark" ]; then
    NEW_THEME="light"
else
    NEW_THEME="dark"
fi

# Guardar el nuevo tema
echo "$NEW_THEME" > ~/.config/theme-mode
export THEME_MODE="$NEW_THEME"

# === ALACRITTY ===
ALACRITTY_DIR="$HOME/dotfiles/alacritty"
TEMP_ALACRITTY=$(mktemp)

if [ "$NEW_THEME" = "light" ]; then
    cat "$ALACRITTY_DIR/base.toml" "$ALACRITTY_DIR/catppuccin-latte.toml" > "$TEMP_ALACRITTY"
else
    cat "$ALACRITTY_DIR/base.toml" "$ALACRITTY_DIR/catppuccin-mocha.toml" > "$TEMP_ALACRITTY"
fi

mv "$TEMP_ALACRITTY" "$ALACRITTY_DIR/alacritty.toml"

# === TMUX ===
TMUX_DIR="$HOME/dotfiles/tmux"
TEMP_TMUX=$(mktemp)

if [ "$NEW_THEME" = "light" ]; then
    cat "$TMUX_DIR/base.conf" "$TMUX_DIR/catppuccin-latte.conf" > "$TEMP_TMUX"
else
    cat "$TMUX_DIR/base.conf" "$TMUX_DIR/catppuccin-mocha.conf" > "$TEMP_TMUX"
fi

mv "$TEMP_TMUX" "$TMUX_DIR/tmux.conf"

# Recargar tmux si está corriendo
if command -v tmux &> /dev/null && tmux list-sessions &> /dev/null; then
    tmux source-file "$TMUX_DIR/tmux.conf"
fi

# === NVIM ===
nvr --serverlist | while read server; do
    nvr --servername "$server" -c "lua require('theme-switcher').reload()" 2>/dev/null || true
done

# === BTOP ===
BTOP_DIR="$HOME/dotfiles/btop/themes"
BTOP_CONFIG="$HOME/.config/btop"

if [ -d "$BTOP_CONFIG" ]; then
    mkdir -p "$BTOP_CONFIG/themes"
    
    if [ "$NEW_THEME" = "light" ]; then
        cp "$BTOP_DIR/catppuccin-latte.theme" "$BTOP_CONFIG/themes/catppuccin-latte.theme"
        sed -i 's/^color_theme = .*/color_theme = "catppuccin-latte"/' "$BTOP_CONFIG/btop.conf"
    else
        cp "$BTOP_DIR/catppuccin-mocha.theme" "$BTOP_CONFIG/themes/catppuccin-mocha.theme"
        sed -i 's/^color_theme = .*/color_theme = "catppuccin-mocha"/' "$BTOP_CONFIG/btop.conf"
    fi
    
    # btop will automatically reload the theme on next update cycle
fi

