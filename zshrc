#
# .zshrc is sourced in interactive shells.
# It should contain commands to set up aliases,
# functions, options, key bindings, etc.
#

autoload -U compinit
compinit

autoload -Uz vcs_info
autoload -U zmv
autoload -U colors
colors

source ~/.zfunctions.zsh

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
setopt cdabl_evars
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
setopt menu_complete
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

{ which colordiff        >& /dev/null } && alias diff='colordiff'
{ locate macros/less.vim >& /dev/null } && alias vless="vim -u `locate macros/less.vim | head -n1`"


# GNU overrides for OSX:
if [[ $OSTYPE = darwin* ]]; then
	{ which gcp      >& /dev/null } && alias cp='gcp -i'
	{ which gmv      >& /dev/null } && alias mv='gmv -i'
	{ which rm       >& /dev/null } && alias rm='grm -i'
	{ which gls      >& /dev/null } && alias ls='gls --color=auto'
	{ which gmd5sum  >& /dev/null } && alias md5sum='gmd5sum'
	{ which gsha1sum >& /dev/null } && alias shasum='gsha1sum'
	{ which gdu      >& /dev/null } && alias du='gdu'
	{ which gtail    >& /dev/null } && alias tail='gtail'
	{ which ghead    >& /dev/null } && alias head='ghead'
	{ which gln      >& /dev/null } && alias ln='gln'
fi

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

zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# default color for the hostname:
HOST_COLOR="magenta"
case $HOST in
	*.zoocasa.com|*.i.internal)
		HOST_COLOR="cyan"
	;;

	zooburg*)
		HOST_COLOR="yellow"
	;;

	gobstopper*)
		HOST_COLOR="green"
	;;
esac

function-exists vcs_info
if [[ $? = 0 ]]; then
	zstyle ':vcs_info:*'              enable            git svn svk cvs
	zstyle ':vcs_info:*'              disable-patterns "$HOME(|/.*|/bin)"
	zstyle ':vcs_info:*'              actionformats    ' (%F{red}%s%f %F{cyan}%b%f%F{yellow}|%F{1}%a%F{cyan} %B%F{yellow}%c%F{red}%u%%b)'
	zstyle ':vcs_info:*'              formats          ' (%F{red}%s%f %F{cyan}%b%f)'
	zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat     '%b%F{1}:%F{3}%r'
	zstyle ':vcs_info:*'              check-for-changes true
	zstyle ':vcs_info:*'              get-revision      true
#	zstyle ':vcs_info:*'              disable-patterns  "$HOME/.git"

	precmd() {                                                   
	    psvar=()
		vcs_info
		[[ -n $vcs_info_msg_0_ ]] && psvar[1]=" $vcs_info_msg_0_"
	}

	PROMPT=$'%F{white}[%n@%f%F{green}%m%f %c]${vcs_info_msg_0_}%b%F%f%# '
else
	PROMPT=$'%{$fg[white]%}[%n@%{$fg[$HOST_COLOR]%}%m%{$fg[white]%} %c]%{$reset_color%}%# '
fi

export JZSHRC=1

