# FIX vterm % showing up.
unsetopt PROMPT_SP
export ZSH="$HOME/.oh-my-zsh"

#zmodload zsh/zprof  
ZSH_THEME="agnoster"
COMPLETION_WAITING_DOTS="true"
DEFAULT_USER="$USER"

# ZSH Autocomplete https://github.com/marlonrichert/zsh-autocomplete
#source ~/Repos/zsh-autocomplete/zsh-autocomplete.plugin.zsh

#zstyle ':omz:plugins:nvm' lazy yes
plugins=(
    colorize
    history
    zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh
HISTSIZE=5000

export ASDF_DATA_DIR="/home/hubbe/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"
export PATH="$PATH:/home/hubbe/.local/bin"

# append completions to fpath
fpath=(${ASDF_DATA_DIR}/completions $fpath)

# Test speeding up zsh shell
DISABLE_UNTRACKED_FILES_DIRTY="true"  

#disable caps lock
setxkbmap -layout us -option ctrl:nocaps


export FZF_DEFAULT_COMMAND='rg --hidden --files'
export EDITOR="emacsclient -c"
export ELIXIR_EDITOR="emacsclient __FILE__"

export LOCALHOST_SSL_CERT="$HOME/Certs/localhost.crt"
export LOCALHOST_SSL_KEY="$HOME/Certs/localhost.key"


alias tmx="tmux new-session -s"

alias edit='emacsclient -nw -a "" $(fzf)'
alias cat="bat --no-pager"
alias ls=exa
alias ks=kubectl
alias dps='docker ps -a --format "table {{.Names}}\t{{.Status}}\t{{.Networks}}\t{{.Ports}}"'
alias tree='exa --long --tree -a'

mmk() {
	mkdir -p $1 && cd $1
}


export ERL_AFLAGS="-kernel shell_history enabled"

# ASDF Java configuraton
. ~/.asdf/plugins/java/set-java-home.zsh

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
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"


# pnpm
export PNPM_HOME="/home/hubbe/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PATH:$PNPM_HOME" ;;
esac
# pnpm end

