eval "$(/opt/homebrew/bin/brew shellenv)"

PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-time/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/gnu-which/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"

# For scripts installed by pipx
PATH="$HOME/.local/bin:$PATH"
