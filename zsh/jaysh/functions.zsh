
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


function butterfly() {
  echo 'Ƹ̵̡Ӝ̵̨̄Ʒ'
}

function look-of-disapproval() {
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

function table-flip() {
  echo "(╯°□°）╯︵ $1"
}

function glasses() {
  echo "( •_•)"
  echo "( •_•)>⌐■-■"
  echo "(⌐■_■)"
}

function term-title() {
  echo -n -e "\033]0;$1\007"
}

function susu() {
  if [ "$#" -eq 0 ]; then
    echo "susu: Does \`sudo su \$@\`"
  else
    sudo su $@
  fi
}

function fix-terminal() {
  echo -e "\033c"
}

