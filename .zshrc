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

WORDCHARS=$(echo $WORDCHARS | tr -d "/")

setopt AUTO_CD

setopt MULTIOS

autoload -U zmv

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-history-substring-search/zsh-history-substring-search.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

source /opt/homebrew/opt/zsh-git-prompt/zshrc.sh
PROMPT='%F{blue}%B%~%b%f %# '
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_CHANGED="%{$fg[yellow]%}%{✚%G%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%}%{✔%G%}"
ZSH_THEME_GIT_PROMPT_CONFLICTS="%{$fg[red]%}%{✖%G%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}%{●%G%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%}%{…%G%}"
RPROMPT='$(git_super_status)'
export VIRTUAL_ENV_DISABLE_PROMPT="true"

export EDITOR="code"

eval "$(direnv hook zsh)"
eval "$(npm completion)"

export AWS_CLI_AUTO_PROMPT="on-partial"

[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && source /opt/homebrew/etc/profile.d/autojump.sh

[ -f "${HOME}/.iterm2_shell_integration.zsh" ] && source "${HOME}/.iterm2_shell_integration.zsh"

alias df="df -h"
alias du="du -h"
alias grep="grep --color=auto -P"
alias ll="ls -l"
alias ls="ls --color=auto -h"
alias rsync="rsync -h"

alias python="python3"

alias ql="qlmanage -p > /dev/null 2> /dev/null"
