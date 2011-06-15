
function function-exists() {
  local -a files
  files=(${^fpath}/$1(N))
  (( ${#files} ))
}

function svn-grep() {
  grep $@ | grep svn -v | grep $1
}

function svn-diff() {
  svn diff $@ | colordiff | less -R
}

function svn-log() {
  svn log $@ | less
}

function cool-date() {
  date +%Y.%m.%d.%H.%M.%S
}

function zoo-diff() {
  vimdiff -o \
    =(wget -O - $1 | gsed "s/assets[0-3]/assets/g" | gsed "s/?[0-9]\+//g") \
    =(wget -O - $2 | gsed "s/assets[0-3]/assets/g" | gsed "s/old_trunk/trunk/g" | gsed "s/?[0-9]\+//g")
}

if [[ $OSTYPE = darwin* ]]; then
  function growl() {
    $@
    RETVAL=$?
    if [ $RETVAL = 0 ]; then
      echo ${@} | growlnotify --sticky "SUCCESS"
    else
      echo ${@} | growlnotify --sticky "ERROR ($RETVAL)"
    fi
  }
fi

function bak() {
  for i in $@; do
    cp "${i}" "${i}~"
  done
}

function unbak() {
  for i in $@; do
    cp "${i}~" "${i}"
  done
}

function reset-terminal() {
  echo '\033c'
}

function flush-dns() {
  if [[ $OSTYPE = darwin* ]]; then
    dscacheutil -flushcache
  fi
}





function butterfly() {
  echo 'Ƹ̵̡Ӝ̵̨̄Ʒ'
}

function crazy-eyes() {
  echo "ಠ_ಠ"
}

function goon-say() {
  echo " __________"
  echo "(--[ .]-[ .] /"
  echo "(_______O__)"
}

function bunny() {
  echo "(\\(\\"
  echo "(^.^)"
  echo "(\\\")\\\")"
}

function confused-bunny() {
  echo "(\\ /)"
  echo "(O.o)"
  echo "(> <)"
}

function ipod() {
  echo "╔════╗ ♪"
  echo "║ ███║ ♫"
  echo "║ (●)║ ♫"
  echo "╚════╝♪♪"
}

function pokemon() {
  echo "(づ｡◕‿‿◕｡)づ"
}

function lol-wut() {
  echo "█▄▄ ███ █▄▄ █▄█▄█ █▄█ ▀█▀"
}
