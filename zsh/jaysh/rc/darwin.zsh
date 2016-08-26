
setopt noignoreeof

function csshXi() {
  BOXES=()
  for i in $@; do
    BOXES+="$i.i.internal"
  done

  csshX ${BOXES}
}

# GNU overrides for OSX:
{ which gcp      >& /dev/null } && alias cp='gcp -i'
{ which gmv      >& /dev/null } && alias mv='gmv -i'
{ which grm      >& /dev/null } && alias rm='grm -i'
{ which gls      >& /dev/null } && alias ls='gls --color=auto'
#{ which gmd5sum  >& /dev/null } && alias md5sum='gmd5sum'
#{ which gsha1sum >& /dev/null } && alias shasum='gsha1sum'
{ which gdu      >& /dev/null } && alias du='gdu'
{ which gtail    >& /dev/null } && alias tail='gtail'
{ which ghead    >& /dev/null } && alias head='ghead'
{ which gln      >& /dev/null } && alias ln='gln'
{ which gmkdir   >& /dev/null } && alias mkdir='gmkdir'
{ which gtac     >& /dev/null } && alias tac='gtac'

# other aliases
alias vi='vim'
alias mysql="env EDITOR='vim -c \"set ft=sql\"' mysql"

# some environment settings
EDITOR="/opt/local/bin/vim"

# spit out a fortune on login.
HOME_FORTUNE="$HOME/.fortune"
LOCAL_FORTUNE="/usr/local/share/games/fortune"
DEFAULT_FORTUNE="/usr/share/games/fortune"

which fortune >& /dev/null
if [ "$?" = "0" ]; then
  if [ -e "$HOME_FORTUNE" ]; then
    if [ -d "$HOME_FORTUNE" ]; then
      FORTUNE_DIR="$HOME_FORTUNE"
    elif [ -f "$HOME_FORTUNE" ]; then
      cat "$HOME_FORTUNE"
    fi
  elif [ -d "$LOCAL_FORTUNE" ]; then
    FORTUNE_DIR="$LOCAL_FORTUNE"
  elif [ -d "$DEFAULT_FORTUNE" ]; then
    FORTUNE_DIR="$DEFAULT_FORTUNE"
  fi

  if [ "$FORTUNE_DIR" != "" ]; then
    echo
    fortune $FORTUNE_DIR | sed "s/^/  /"
    echo
  fi
fi

