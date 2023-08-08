# lytux live .bashrc

[[ $- != *i* ]]&& return


shopt -s autocd cdspell dirspell cdable_vars

alias b='bash'
alias v='vim'

alias ls='ls --file-type --color=auto'
alias la='ls -A'
alias ll='ls -l'

alias rm='rm -fr'

if (( EUID )); then
  SYMBOL='$'
else
  SYMBOL='#'
fi

prompt_command(){
  [[ $PWD =~ ^$HOME ]]&& { PWD="${PWD#$HOME}" PWD="~$PWD"; }
  printf '\e[2;33m%s\e[m\n' "$PWD"
}

PROMPT_COMMAND=prompt_command

PS1="\[\e[35m\]\$USER\[\e[m\]@\[\e[36m\]\$HOSTNAME\[\e[m\] \
\$((( \$? ))\
  && printf '\[\e[31m\]$SYMBOL\[\e[m\]> '\
  || printf '\[\e[32m\]$SYMBOL\[\e[m\]> ')"

PS4="-[\e[33m${BASH_SOURCE[0]%.sh}\e[m: \e[32m${LINENO}\e[m]\
  ${FUNCNAME[0]:+${FUNCNAME[0]}(): }"
