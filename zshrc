
for i in ~/.zsh/jaysh/include.d/*.zsh; do
  source $i
done

export JZSHRC=1

source-jaysh-os "rc"

compinit
