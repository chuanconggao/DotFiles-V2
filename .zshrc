autoload -U bashcompinit
bashcompinit

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

eval "$(dircolors -b)"
autoload -U colors && colors
zle_highlight=(default:fg=yellow)

autoload -U compinit && compinit
zmodload zsh/complist
zstyle ':completion:*' use-cache on
zstyle ':completion:*' list-colors $LS_COLORS
zstyle ':completion:*:*:*' menu yes select

HISTSIZE=1000000
SAVEHIST=1000000
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY

setopt AUTO_REMOVE_SLASH
setopt EXTENDED_GLOB
setopt GLOB_STAR_SHORT
setopt NUMERIC_GLOB_SORT
unsetopt CASE_GLOB
unsetopt CASE_MATCH
unsetopt LIST_TYPES
unsetopt MARK_DIRS

WORDCHARS=$(echo $WORDCHARS | tr -d '\-/=')

setopt AUTO_CD

setopt MULTIOS

autoload -U zmv

# In default, when pressing <Ctrl-u>, Zsh clears entire line instead of line before cursor.
bindkey \^U backward-kill-line

# Must be before auto suggestions for its proper highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh

setopt PROMPT_SUBST

function git_prompt_precmd() {
    if [[ $LAST_PWD == $PWD ]]; then
        CURRENT_TIME="$(date +%s)"
        if [[ $LAST_GIT_PROMPT_TIME == $CURRENT_TIME ]]; then
            return
        fi

        LAST_GIT_PROMPT_TIME=$CURRENT_TIME
    else
        LAST_GIT_PROMPT_TIME=""
        LAST_PWD=$PWD
    fi

    RAW_GIT_PROMPT="$(print_git_prompt 2> /dev/null)"
    if [[ -z $RAW_GIT_PROMPT ]]; then
        GIT_PROMPT=""
    else
        GIT_PROMPT=" ($RAW_GIT_PROMPT)"
    fi
}
autoload -U add-zsh-hook
add-zsh-hook precmd git_prompt_precmd

PROMPT=$'┌ %F{blue}%B%~%b%f${GIT_PROMPT}\n└ %# '
export VIRTUAL_ENV_DISABLE_PROMPT="true"

export HOMEBREW_NO_ENV_HINTS="true"

export HOMEBREW_NO_ANALYTICS=1

export DDB_LOCAL_TELEMETRY=0

export EDITOR="code"

eval "$(direnv hook zsh)"
eval "$(npm completion)"
complete -C '/opt/homebrew/bin/aws_completer' aws
complete -C '/opt/homebrew/bin/aws_completer' awslocal

export AWS_CLI_AUTO_PROMPT="on-partial"

export PIPENV_VENV_IN_PROJECT=1

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && source /opt/homebrew/etc/profile.d/autojump.sh

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

alias df="df -h"
alias du="du -h"
alias grep="grep --color=auto -P"
alias ll="ls -l"
alias ls="ls --color=auto -h"
alias rsync="rsync -h"

alias mkdir="mkdir -p"

alias echo="echo -e"

alias python="python3"
alias ipython="ipython --no-confirm-exit"

alias ql="qlmanage -p > /dev/null 2> /dev/null"
