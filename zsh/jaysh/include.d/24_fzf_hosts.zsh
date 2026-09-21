#!/bin/zsh
# Override fzf's __fzf_list_hosts (see 25_fzf.zsh) so that SSH hosts defined
# in ~/.ssh/clients/**/* (included from ~/.ssh/config via "Include
# clients/**/*") are also picked up for completion, not just ~/.ssh/config
# and ~/.ssh/config.d/*.

__fzf_list_hosts() {
  command sort -u \
    <(
      setopt LOCAL_OPTIONS GLOB NO_DOT_GLOB CASE_GLOB NO_NOMATCH NULL_GLOB

      awk '
        match(tolower($0), /^[ \t]*host(name)?[ \t]*[ \t=]/) {
          $0 = substr($0, RLENGTH + 1) # Remove "Host(name)?=?"
          sub(/#.*/, "")
          for (i = 1; i <= NF; i++)
            if ($i !~ /[*?%]/)
              print $i
        }
      ' ~/.ssh/config ~/.ssh/config.d/* /etc/ssh/ssh_config \
        $(find ~/.ssh/clients -type f -not -name '.DS_Store' 2> /dev/null) \
        2> /dev/null
    ) \
    <(
      awk -F ',' '
        match($0, /^[][a-zA-Z0-9.,:-]+/) {
          $0 = substr($0, 1, RLENGTH)
          gsub(/[][]|:[^,]*/, "")
          for (i = 1; i <= NF; i++)
            print $i
        }
      ' ~/.ssh/known_hosts 2> /dev/null
    ) \
    <(
      awk '
        {
          sub(/#.*/, "")
          for (i = 2; i <= NF; i++)
            if ($i != "0.0.0.0")
              print $i
        }
      ' /etc/hosts 2> /dev/null
    )
}
