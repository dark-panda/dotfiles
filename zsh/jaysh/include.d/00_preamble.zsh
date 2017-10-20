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
