#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

function source-jaysh() {
  [ -r ~/"$1" ] && source ~/"$1"
}

function source-jaysh-os() {
  [[ -n "$OS_ZSH" ]] && [ -r ~/".zsh/jaysh/$1/$OS_ZSH.zsh" ] && source ~/".zsh/jaysh/$1/$OS_ZSH.zsh"
  [ -r ~/".zsh/jaysh/$1/local.zsh" ] && source ~/".zsh/jaysh/$1/local.zsh"
}

case $OSTYPE in
  darwin*)
    OS_ZSH="darwin"
  ;;

  linux*)
    OS_ZSH="linux"
  ;;

  freebsd*)
    OS_ZSH="freebsd"
  ;;
esac

[ -z "$JZPROFILE" ] && source-jaysh ".zprofile"
source-jaysh-os "profile"

autoload -U compinit
autoload -Uz vcs_info
autoload -U zmv
autoload -U colors
colors

source-jaysh ".zsh/jaysh/functions.zsh"
source-jaysh-os "functions"

HISTSIZE=2000
SAVEHIST=2000
HISTFILE=~/.zhistory

setopt complete_in_word
setopt all_export
setopt append_history
setopt auto_cd
setopt auto_list
setopt auto_param_slash
setopt auto_pushd
setopt auto_resume
setopt cdable_vars
setopt correct
setopt correct_all
setopt extended_glob
setopt extended_history
setopt glob_dots
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_no_functions
setopt hist_no_store
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt inc_append_history
setopt long_list_jobs
setopt mail_warning
setopt no_hist_beep
setopt no_beep
setopt notify
setopt pushd_minus
setopt pushd_silent
setopt pushd_to_home
setopt rc_quotes
setopt rec_exact
setopt share_history
setopt prompt_subst
unsetopt bg_nice
unsetopt menu_complete

zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
if [ -z "$mapfile" ]; then
  zmodload -ap zsh/mapfile mapfile
fi

alias ll='ls -l'
alias dir='ls'
alias links='elinks'
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias grep='grep --color=auto'
alias vi='vim'

# disable autocorrect on some commands
alias sudo='nocorrect sudo'
alias git='nocorrect git'
alias bundle='nocorrect bundle'

{ which colordiff >& /dev/null } && alias diff='colordiff'
{ locate macros/less.sh >& /dev/null } && alias vless="`locate macros/less.sh | head -n1`"

bindkey "^?" backward-delete-char
bindkey "^r" history-incremental-search-backward
bindkey ' ' magic-space    # also do history expansion on space
#bindkey '^I' complete-word # complete on tab, leave expansion to _expand
bindkey '^I' expand-or-complete-prefix
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[OH' beginning-of-line
bindkey '^[OF' end-of-line
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '\e[3~' delete-char
bindkey '\e[1;5C' forward-word
bindkey '\e[1;5D' backward-word
bindkey '^B' delete-word

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu select=2

# default color for the hostname:
HOST_COLOR="green"
if [[ -n "$SSH_CLIENT" ]]; then
  HOST_COLOR="yellow"
fi

function-exists vcs_info
if [[ $? = 0 ]]; then
  zstyle ':vcs_info:*'              enable            git svn svk cvs hg
  zstyle ':vcs_info:*'              actionformats    ' (%F{red}%s%f %F{cyan}%b%f%F{yellow}|%F{1}%a%F{cyan}%f) %B%F{yellow}%c%F{red}%u%%b'
  zstyle ':vcs_info:*'              formats          ' (%F{red}%s%f %F{cyan}%b%f) %B%F{yellow}%c%F{red}%u%%b'
  zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat     '%b%F{1}:%F{3}%r'
  zstyle ':vcs_info:*'              check-for-changes true
  zstyle ':vcs_info:*'              get-revision      true

  precmd() {
    psvar=()
    vcs_info
    [[ -n $vcs_info_msg_0_ ]] && psvar[1]=" $vcs_info_msg_0_"
  }

  PROMPT=$'%F{white}[%n@%f%F{$HOST_COLOR}%m%f %c]${vcs_info_msg_0_}%b%F%f%# '
else
  PROMPT=$'%{$fg[white]%}[%n@%{$fg[$HOST_COLOR]%}%m%{$fg[white]%} %c]%{$reset_color%}%# '
fi

if [[ -d ~/.zsh/zsh-completions-git/src ]]; then
  fpath=(~/.zsh/zsh-completions-git/src $fpath)
fi

export JZSHRC=1

source-jaysh-os "rc"

compinit

