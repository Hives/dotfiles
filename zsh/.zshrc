##############################################################################
# Global
##############################################################################

# Create a hash table for globally stashing variables without polluting main
# scope with a bunch of identifiers.
typeset -A __HIVEMIND

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
  if [[ $#BUFFER -eq -0 ]]; then
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
bindkey "$key[Up]" history-beginning-search-backward
bindkey "$key[Down]" history-beginning-search-forward

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
# this must come after changes to fpath
autoload -U compinit
compinit -u

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

export HISTSIZE=100000
export HISTFILE="$HOME/.history"
export SAVEHIST=$HISTSIZE
setopt extended_history
setopt histignorealldups    # filter duplicates from history
# setopt histignorespace      # don't record commands starting with a space
setopt histverify           # confirm history expansion (!$, !!, !foo)
setopt sharehistory         # share history across shells

HIST_STAMPS="yyyy-mm-dd"
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
alias sudo='nocorrect sudo'
setopt listpacked           # make completion lists more densely packed
# setopt menucomplete         # auto-insert first possible ambiguous completion
setopt printexitvalue       # for non-zero exit status
setopt pushdignoredups      # don't push multiple copies of same dir onto stack
setopt pushdsilent          # don't print dir stack after pushing/popping

##############################################################################
# Plugins
##############################################################################

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'

source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##############################################################################
# Prompt
##############################################################################

# starship prompt
eval "$(starship init zsh)"

##############################################################################
# Stuffs
##############################################################################

# aliases
source ~/.config/aliases/aliases

# autojump
[ -f /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh

# base16 colors
# BASE16_SHELL="$HOME/.config/base16-shell/"
# [ -n "$PS1" ] && \
#     [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
#         eval "$("$BASE16_SHELL/profile_helper.sh")"

# binaries go in here
PATH=$HOME/.local/bin:$PATH

# default editor = neovim
neovim_path=/home/hives/.local/bin/nvim.appimage
export EDITOR=$neovim_path
export VISUAL=$neovim_path

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fdfind --hidden --exclude .git --type f' # requires fd-find obv
export FZF_DEFAULT_OPTS='--color bg+:18,fg+:07' # seems to make it play better with base16

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/hives/.local/bin/google-cloud-sdk/path.zsh.inc' ]; then . '/home/hives/.local/bin/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/hives/.local/bin/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/hives/.local/bin/google-cloud-sdk/completion.zsh.inc'; fi

# kubectl autocompletion
if [ -x "$(command -v kubectl)" ]; then source <(kubectl completion zsh); fi

# linux brew??
eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# node
# - fnm
export PATH=/home/hives/.fnm:$PATH
eval "`fnm env --multi`"
source ~/.zsh/node-autoswitch.sh
# - yarn
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# SDKMAN - THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/home/hives/.sdkman"
[[ -s "/home/hives/.sdkman/bin/sdkman-init.sh" ]] && source "/home/hives/.sdkman/bin/sdkman-init.sh"
