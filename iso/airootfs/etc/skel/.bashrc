# lytux live .bashrc

[[ $- != *i* ]]&& return

shopt -s autocd cdspell dirspell cdable_vars

alias b='bash'
alias v='vim'

alias ls='ls --file-type --color=auto'
alias la='ls -A'
alias ll='ls -l'

alias rm='rm -fr'

if (( EUID )); then SYMBOL='$'; else SYMBOL='#'; fi

prompt_command(){
  unset branch tag

  [[ $PWD =~ ^$HOME ]]&& { PWD="${PWD#$HOME}" PWD="~$PWD"; }

  local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  local tag="$(git describe --tags --abbrev=0 2>/dev/null)"

  [[ $branch ]]&& branch=" $branch"

  printf '\e[2;33m%s\e[m \e[2m%s %s\e[m\n' "$PWD" "$branch" "$tag"
}

PROMPT_COMMAND=prompt_command

PS1="\[\e[4;35m\]\$USER\[\e[m\]@\[\e[4;36m\]\$HOSTNAME\[\e[m\] \
\$((( \$? ))\
  && printf '\[\e[1;31m\]$SYMBOL\[\e[m\]≫ '\
  || printf '\[\e[1;32m\]$SYMBOL\[\e[m\]≫ ')"

PS4="-[\e[33m${BASH_SOURCE[0]%.sh}\e[m: \e[32m${LINENO}\e[m]\
  ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
