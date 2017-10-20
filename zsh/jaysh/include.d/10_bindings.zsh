
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
bindkey '^B' delete-word
