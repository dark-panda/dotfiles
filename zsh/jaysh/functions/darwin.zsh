
function growl() {
  $@
  RETVAL=$?
  if [ $RETVAL = 0 ]; then
    echo ${@} | growlnotify --sticky "SUCCESS"
  else
    echo ${@} | growlnotify --sticky "ERROR ($RETVAL)"
  fi
}

function flush-dns() {
  dscacheutil -flushcache
}
