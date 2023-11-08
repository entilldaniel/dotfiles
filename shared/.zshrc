export ZSH="$HOME/.oh-my-zsh"

#zmodload zsh/zprof  
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

export PATH=$PATH:/home/hubbe/development/flutter/bin

#enable ASDF
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
# initialise completions with ZSH's compinit

# initialise completions with ZSH's compinit
#autoload -Uz compinit && (compinit &) 
# autoload -Uz compinit 
# if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
# 	compinit; 
# else
# 	compinit -C;
# fi;


# Test speeding up zsh shell
DISABLE_UNTRACKED_FILES_DIRTY="true"  

#disable caps lock
setxkbmap -option ctrl:nocaps

export EDITOR="emacsclient -nw"
alias edit=$EDITOR

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"


export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#zprof
