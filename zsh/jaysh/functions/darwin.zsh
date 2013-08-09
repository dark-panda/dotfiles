
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
  sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
  sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.mDNSResponder.plist
}
