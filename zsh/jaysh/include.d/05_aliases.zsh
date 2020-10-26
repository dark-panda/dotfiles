
alias ll='ls -l'
alias lh='ls -lh'
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
