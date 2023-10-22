export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"

plugins=(
    git
    colorize
    history
    fzf
)

source $ZSH/oh-my-zsh.sh
HISTSIZE=2500

export PATH="$PATH:$HOME/development/flutter/bin:$HOME/.local/bin"

#enable ASDF
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

#disable caps lock
setxkbmap -option ctrl:nocaps

export EDITOR="emacsclient -nw"


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
