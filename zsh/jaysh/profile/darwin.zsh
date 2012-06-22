
# macports
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export MANPATH=$MANPATH:/opt/local/share/man

# rbenv
if [ -d $HOME/.rbenv ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
  eval "$(rbenv init -)"
fi

