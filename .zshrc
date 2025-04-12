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

function venv_prompt_precmd() {
    if [[ -z $VIRTUAL_ENV ]] then
        VENV_PROMPT=""
    else
        if [[ $LAST_VIRTUAL_ENV == $VIRTUAL_ENV ]] then
            return
        fi

        # We do not use VIRTUAL_ENV_PROMPT as:
        # - It is not always set when VIRTUAL_ENV_DISABLE_PROMPT is set
        # - It is fixed at creation time of venv and cannot be updated
        VENV_PY_VERSION=$(python --version | grep -o "[0-9]+\.[0-9]+")
        VENV_PROMPT=" (%F{yellow}py$VENV_PY_VERSION%f)"
    fi

    LAST_VIRTUAL_ENV=$VIRTUAL_ENV
}

function nvm_prompt_precmd() {
    if [[ -z $NVM_BIN ]] then
        NVM_PROMPT=""
    else
        if [[ $LAST_NVM_BIN == $NVM_BIN ]] then
            return
        fi

        NODE_VERSION=$($NVM_BIN/node --version | grep -o "v[0-9]+" | tr -d "v")
        NVM_PROMPT=" (%F{red}node$NODE_VERSION%f)"
    fi

    LAST_NVM_BIN=$NVM_BIN
}

autoload -U add-zsh-hook
add-zsh-hook precmd git_prompt_precmd
add-zsh-hook precmd venv_prompt_precmd
add-zsh-hook precmd nvm_prompt_precmd

PROMPT=$'┌ %F{blue}%B%~%b%f${GIT_PROMPT}${VENV_PROMPT}${NVM_PROMPT}\n└ %# '
export VIRTUAL_ENV_DISABLE_PROMPT="true"

export HOMEBREW_NO_ENV_HINTS="true"

export HOMEBREW_NO_ANALYTICS=1

export DDB_LOCAL_TELEMETRY=0

export EDITOR="code"

eval "$(direnv hook zsh)"
eval "$(mise activate zsh)"

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

# Enable ANSI color
alias less="less -R -M --use-color"
export PAGER="less -R -M --use-color"
# Avoid less interpreting `:`
export LESSEDIT="%E --goto %g\\:%lm"

alias ql="qlmanage -p > /dev/null 2> /dev/null"
