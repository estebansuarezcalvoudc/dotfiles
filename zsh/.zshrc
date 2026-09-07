# Omarchy dotfiles — zsh configuration

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="custom_clean"

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

# --- Language / toolchain managers -------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Conda (only if installed)
for conda_path in "$HOME/anaconda3" "$HOME/miniconda3" "$HOME/opt/anaconda3" "$HOME/opt/miniconda3"; do
    if [ -f "$conda_path/etc/profile.d/conda.sh" ]; then
        . "$conda_path/etc/profile.d/conda.sh"
        break
    fi
done

# --- Aliases ------------------------------------------------------------------
alias vim="nvim"
alias ls="lsd"

# Clipboard (Wayland — wl-clipboard ships with Omarchy)
alias copy='wl-copy'
alias paste='wl-paste'

# --- Zsh plugins (Arch packages: zsh-syntax-highlighting, zsh-autosuggestions)
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# --- Atuin (history) -----------------------------------------------------------
eval "$(atuin init zsh)"

# --- Omarchy theme sync ---------------------------------------------------------
# The theme (light/dark) is synchronized automatically from Omarchy.
export THEME_MODE=$(grep -m1 '^mode' ~/.local/state/omarchy/current/theme/colors.toml 2>/dev/null | grep -o '"[^"]*"' | tr -d '"' || echo "dark")

# --- Herramientas BibTeX ---------------------------------------------------------
# 1. Convertir RIS a BIB solamente. Uso: ris2bib archivo.ris
ris2bib() {
    ris2xml "$1" | xml2bib -b > "${1%.*}.bib"
}

# 2. Convertir RIS a BIB y copiar al portapapeles. Uso: ris2clip archivo.ris
ris2clip() {
    # 'tee' guarda en fichero Y pasa la salida al siguiente comando
    ris2xml "$1" | xml2bib -b | tee "${1%.*}.bib" | wl-copy
}

# --- FSAS / survival_analysis -----------------------------------------------------
# push: proyecto → cluster
alias push_survival_analysis="rsync -auvz --delete --exclude='.git/' --exclude='mlflow/' --exclude='mlflow.db' --exclude='visuals/' --exclude='checkpoints/' --exclude='out/' --exclude='logs/' --exclude='__pycache__/' --exclude='dataset_RedEs' ~/FSAS/survival_analysis/ aborrallo@lantik:/home/lantik-test/aborrallo/esteban_suarez/survival_analysis/"
# fetch: cluster → proyecto
alias fetch_survival_analysis="rsync -auvz --delete --exclude='.git/' --exclude='mlflow/' --exclude='mlflow.db' --exclude='visuals/' --exclude='checkpoints/' --exclude='out/' --exclude='logs/' --exclude='__pycache__/' --exclude='dataset_RedEs' aborrallo@lantik:/home/lantik-test/aborrallo/esteban_suarez/survival_analysis/ ~/FSAS/survival_analysis/"

# push: proyecto/mlflow.db → cluster:/ruta/mlflow.db
alias push_mlflowdb="rsync -av \
  ~/FSAS/survival_analysis/mlflow.db \
  aborrallo@lantik:/home/lantik-test/aborrallo/esteban_suarez/survival_analysis/mlflow.db"
# fetch: cluster:/ruta/mlflow.db → proyecto/mlflow.db
alias fetch_mlflowdb="rsync -av \
  aborrallo@lantik:/home/lantik-test/aborrallo/esteban_suarez/survival_analysis/mlflow.db \
  ~/FSAS/survival_analysis/mlflow.db"
