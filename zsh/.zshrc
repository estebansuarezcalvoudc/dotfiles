# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="custom_clean"

plugins=(fzf-tab)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias vim="nvim"
alias ls="lsd"


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# >>> conda initialize >>>
# Initialize conda if it exists
for conda_path in "$HOME/anaconda3" "$HOME/miniconda3" "$HOME/opt/anaconda3" "$HOME/opt/miniconda3"; do
    if [ -f "$conda_path/etc/profile.d/conda.sh" ]; then
        . "$conda_path/etc/profile.d/conda.sh"
        break
    fi
done
# <<< conda initialize <<<

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
export PATH="$HOME/.config/emacs/bin:$PATH"

# Clipboard alias (cross-platform)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias copy='pbcopy'
    alias paste='pbpaste'
elif command -v xclip &> /dev/null; then
    # Linux with xclip
    alias copy='xclip -selection clipboard'
    alias paste='xclip -selection clipboard -o'
elif command -v xsel &> /dev/null; then
    # Linux with xsel
    alias copy='xsel --clipboard --input'
    alias paste='xsel --clipboard --output'
fi

# >>> Herramientas BibTeX >>>
# 1. Convertir RIS a BIB solamente
# Uso: ris2bib archivo.ris
ris2bib() {
    ris2xml "$1" | xml2bib -b > "${1%.*}.bib"
}

# 2. Convertir RIS a BIB y copiar al portapapeles
# Uso: ris2clip archivo.ris
ris2clip() {
    # Usamos 'tee' para guardar en fichero Y pasar la salida al siguiente comando
    ris2xml "$1" | xml2bib -b | tee "${1%.*}.bib" | xclip -selection clipboard
}
# <<< Herramientas BibTeX <<<
