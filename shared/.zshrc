# FIX vterm % showing up.
unsetopt PROMPT_SP
export ZSH="$HOME/.oh-my-zsh"

#zmodload zsh/zprof  
#ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"

# ZSH Autocomplete https://github.com/marlonrichert/zsh-autocomplete
source ~/Repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh 

#zstyle ':omz:plugins:nvm' lazy yes
plugins=(
    nvm
    git
    colorize
    history
)

source $ZSH/oh-my-zsh.sh
HISTSIZE=5000

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

alias edit='emacsclient -nw -a "" $(fzf)'
alias cat="bat --no-pager"
alias ls=exa
alias ks=kubectl
alias dps='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"'
alias tree='exa --long --tree -a'


# For emacs vterm support
vterm_printf(){
    if [ -n "$TMUX" ]; then
        # Tell tmux to pass the escape sequences through
        # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}

setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

cheat () {
    curl "https://cheat.sh/$1"
}

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(starship init zsh)"
#zprof


# Fix vterm showing %
setopt PROMPT_SP








