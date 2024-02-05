export ZSH="$HOME/.oh-my-zsh"

#zmodload zsh/zprof  
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"

# ZSH Autocomplete https://github.com/marlonrichert/zsh-autocomplete
source ~/Repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh 

zstyle ':omz:plugins:nvm' lazy yes
plugins=(
    nvm
    git
    colorize
    history
)

source $ZSH/oh-my-zsh.sh
HISTSIZE=2500

export PATH=$PATH:/home/hubbe/development/flutter/bin

#enable ASDF
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit

# initialise completions with ZSH's compinit
# autoload -Uz compinit 
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
#     compinit; 
# else
#     compinit -C;
# fi;


# Test speeding up zsh shell
DISABLE_UNTRACKED_FILES_DIRTY="true"  

#disable caps lock
setxkbmap -option ctrl:nocaps

export FZF_DEFAULT_COMMAND='rg --hidden --files'
export EDITOR="emacsclient -nw"

alias edit='$EDITOR $(fzf)'
alias cat="bat --no-pager"
alias ls=exa
alias ks=kubectl
alias dps='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"'
alias tree='exa --long --tree'

cheat () {
    curl "https://cheat.sh/$1"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(starship init zsh)"
#zprof




