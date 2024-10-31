# FIX vterm % showing up.
unsetopt PROMPT_SP
export ZSH="$HOME/.oh-my-zsh"

#zmodload zsh/zprof  
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"

# ZSH Autocomplete https://github.com/marlonrichert/zsh-autocomplete
source ~/Repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh 

#zstyle ':omz:plugins:nvm' lazy yes
plugins=(
    colorize
    history
)

source $ZSH/oh-my-zsh.sh
HISTSIZE=5000

#enable ASDF
. $HOME/.asdf/asdf.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)

# Test speeding up zsh shell
DISABLE_UNTRACKED_FILES_DIRTY="true"  

#disable caps lock
setxkbmap -layout us -option ctrl:nocaps


export FLYCTL_INSTALL="/home/hubbe/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"
export FZF_DEFAULT_COMMAND='rg --hidden --files'
export EDITOR="emacsclient -nw"

alias tmx="tmux new-session -s"
alias edit='emacsclient -nw -a "" $(fzf)'
alias cat="bat --no-pager"
alias ls=exa
alias ks=kubectl
alias dps='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"'
alias tree='exa --long --tree -a'
alias gbuild='./gradlew clean build'

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

eval "$(atuin init zsh)"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm


