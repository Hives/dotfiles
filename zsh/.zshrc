#############################################################################
# Profiling
##############################################################################

# Uncomment this line to enable profiling of zsh startup. Then run `zprof` in
# a new shell to see the results.
# zmodload zsh/zprof

##############################################################################
# Global
##############################################################################

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __HIVEMIND

# keep PATH entries unique (later duplicates are dropped, earliest kept)
typeset -U path PATH

__HIVEMIND[ITALIC_ON]=$'\e[3m'
__HIVEMIND[ITALIC_OFF]=$'\e[23m'

##############################################################################
# Bindings
##############################################################################

bindkey -e # emacs bindings, set to -v for vi bindings

# NOTE: must come before zsh-history-substring-search & zsh-syntax-highlighting.
# only alphanumeric chars are considered WORDCHARS
# so doing C-w on "cd ~/foo/bar"
# results in      "cd ~/foo/"
# rather than     "cd"
autoload -U select-word-style
select-word-style bash

# C-x C-e opens current line in default editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

# shift tab reverse menu (doesn't work with xcape hybrid tab/super)
bindkey '^[[Z' reverse-menu-complete

# Make C-z background things and unbackground them.
function fg-bg() {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
  else
    zle push-input
  fi
}
zle -N fg-bg
bindkey '^z' fg-bg

# breaks signal and menus
bindkey '\e' send-break

# cycle through history based on characters already typed on the line
# bindkey "$key[Up]" history-beginning-search-backward
# bindkey "$key[Down]" history-beginning-search-forward

# Homebrew must run before compinit so its completions are in FPATH.
# first match wins (Apple Silicon, Intel macOS, Linuxbrew)
for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
    break
  fi
done
unset brew_bin

##############################################################################
# Completion
##############################################################################

COMPLETIONS_FOLDER="$HOME/.zsh/completions"

# create completions directory if it doesn't exist
if [ ! -d "$COMPLETIONS_FOLDER" ]; then mkdir "$COMPLETIONS_FOLDER"; fi
fpath=("$COMPLETIONS_FOLDER" $fpath)

# gopass autocompletion
if [ -x "$(command -v gopass)" ]; then
  if [ ! -f "$COMPLETIONS_FOLDER/_gopass" ]; then
    gopass completion zsh > "$COMPLETIONS_FOLDER/_gopass"
  fi
fi

# compinit = initialise completion system
# Fast compinit caching (macOS & Linux compatible)
autoload -Uz compinit
ZSH_COMPDUMP="${ZDOTDIR:-$HOME}/.zcompdump"

zmodload -F zsh/stat b:zstat
if [[ -s "$ZSH_COMPDUMP" ]] && zstat -A compdump_stat +mtime -- "$ZSH_COMPDUMP" 2>/dev/null && (( compdump_stat[1] > $(date +%s) - 86400 )); then
  compinit -C -d "$ZSH_COMPDUMP"
else
  compinit -d "$ZSH_COMPDUMP"
  touch "$ZSH_COMPDUMP"
fi

# Compile zcompdump to byte-code if changed
if [[ -s "$ZSH_COMPDUMP" && (! -s "${ZSH_COMPDUMP}.zwc" || "$ZSH_COMPDUMP" -nt "${ZSH_COMPDUMP}.zwc") ]]; then
  zcompile "$ZSH_COMPDUMP"
fi

# Make completion:
# - Case-insensitive.
# - Accept abbreviations after . or _ or - (ie. f.b -> foo.bar).
# - Substring complete (ie. bar -> foobar).
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Menu-style autocompletion (navigate with arrow keys)
zstyle ':completion:*' menu select

# Colorize completions using default `ls` colors.
zstyle ':completion:*' list-colors ''

# Categorize completion suggestions with headings:
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format %F{default}%B%{$__HIVEMIND[ITALIC_ON]%}--- %d ---%{$__HIVEMIND[ITALIC_OFF]%}%b%f

##############################################################################
# History
##############################################################################

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt histignorealldups    # filter duplicates from history
# setopt histignorespace      # don't record commands starting with a space
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY           # confirm history expansion (!$, !!, !foo)
setopt INC_APPEND_HISTORY_TIME
setopt SHARE_HISTORY         # share history across shells

alias history="history -t'%F %T'"

##############################################################################
# Hooks
##############################################################################

autoload -U add-zsh-hook

# adds `cdr` command for navigating to recent directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# enable menu-style completion for cdr
zstyle ':completion:*:*:cdr:*:*' menu selection

# fall through to cd if cdr is passed a non-recent dir as an argument
zstyle ':chpwd:*' recent-dirs-default true

# # auto ls after cd
# function -auto-ls-after-cd() {
#   emulate -L zsh
#   # Only in response to a user-initiated `cd`, not indirectly (eg. via another
#   # function).
#   if [ "$ZSH_EVAL_CONTEXT" = "toplevel:shfunc" ]; then
#     ls -a
#   fi
# }
# add-zsh-hook chpwd -auto-ls-after-cd

##############################################################################
# Options
##############################################################################

setopt autocd               # .. is shortcut for cd .. (etc)
setopt autopushd            # cd automatically pushes old dir onto dir stack
setopt correct              # command auto-correction
# alias sudo='nocorrect sudo'
alias npm='nocorrect npm'
setopt listpacked           # make completion lists more densely packed
# setopt menucomplete         # auto-insert first possible ambiguous completion
setopt printexitvalue       # for non-zero exit status
setopt pushdignoredups      # don't push multiple copies of same dir onto stack
setopt pushdsilent          # don't print dir stack after pushing/popping

##############################################################################
# Plugins
##############################################################################

[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

# fast-syntax-highlighting is loaded at the end of this file

##############################################################################
# Prompt
##############################################################################

# starship prompt
eval "$(starship init zsh)"

##############################################################################
# Stuffs
##############################################################################

# tmux sessionizer
# run_tmux_session () {
#     tmux-session
# }
# zle -N run_tmux_session
# bindkey ^x run_tmux_session
bindkey -s ^t^m "tmux-session\n"

# time zsh startup
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do time $shell -i -c exit; done
}

# aliases
[ -f ~/.config/aliases/aliases ] && source ~/.config/aliases/aliases

# zoxide - zoxide is a smarter cd command, inspired by z and autojump
if command -v zoxide >/dev/null 2>&1; then eval "$(zoxide init zsh)"; fi

# base16 colors
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"

# binaries go in here
PATH=$HOME/.local/bin:$PATH

# secret executables go in here
PATH=$HOME/bin-secret:$PATH

# personal executables subfolder
PATH=$HOME/bin:$PATH

# personal executables subfolder
PATH=$HOME/bin/gcp:$PATH

export EDITOR=nvim
export VISUAL=nvim

# fzf
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi
# fd is named fdfind on Debian/Ubuntu
if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fd --hidden --exclude .git --type f'
elif command -v fdfind >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND='fdfind --hidden --exclude .git --type f'
fi
# export FZF_DEFAULT_OPTS='--color bg+:18,fg+:07' # seems to make it play better with base16

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/.local/bin/google-cloud-sdk/path.zsh.inc"; fi
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc" ]; then . "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/.local/bin/google-cloud-sdk/completion.zsh.inc"; fi
if [ -n "$HOMEBREW_PREFIX" ] && [ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOMEBREW_PREFIX/share/google-cloud-sdk/completion.zsh.inc"; fi

# Lazy load kubectl autocompletion
# Check if 'kubectl' is a command in $PATH
if (( $+commands[kubectl] )); then
  # Placeholder 'kubectl' shell function:
  # Will only be executed on the first call to 'kubectl'
  kubectl() {
    # Remove this function, subsequent calls will execute 'kubectl' directly
    unfunction "$0"
    # Load auto-completion
    source <(kubectl completion zsh)
    # Pretty colours
    compdef kubecolor=kubectl
    # Execute 'kubectl' binary
    $0 "$@"
  }
fi

# - yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# kubectl authentication https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# go
export PATH=$PATH:/usr/local/go/bin

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# fnm
export PATH="$HOME/.local/share/fnm:$PATH"
if command -v fnm >/dev/null 2>&1; then eval "$(fnm env --use-on-cd)"; fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/shims:$PATH"
# Enable shell integration without spawning rehash subshells
if command -v pyenv >/dev/null 2>&1; then eval "$(pyenv init - --no-rehash)"; fi
# Automatically rehash pyenv after pip install/uninstall
_pyenv_rehash_after_pip() {
  local cmd=$1
  shift
  command "$cmd" "$@"
  local status=$?
  if [[ "$1" == "install" || "$1" == "uninstall" ]] && [ $status -eq 0 ]; then
    pyenv rehash
  fi
  return $status
}
pip() { _pyenv_rehash_after_pip pip "$@"; }
pip3() { _pyenv_rehash_after_pip pip3 "$@"; }

# SDKMAN - THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

if [ -n "$HOMEBREW_PREFIX" ] && [ -d "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" ]; then
  export PATH="$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
fi

# syntax highlighting wraps line editor widgets, so it must load last
[ -f ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh ] && source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
