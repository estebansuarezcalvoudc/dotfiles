# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="custom_clean"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

plugins=(fzf-tab)

source $ZSH/oh-my-zsh.sh

export EDITOR='nvim'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias vim="nvim"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# export PATH="$HOME/anaconda3/bin:$PATH"  # commented out by conda initialize
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/esteban/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/esteban/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/esteban/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/esteban/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias ls="lsd"

. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
export PATH="$HOME/.config/emacs/bin:$PATH"

alias copy='xclip -selection clipboard'

# --- Herramientas BibTeX ---

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
