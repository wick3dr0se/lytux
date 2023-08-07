# ~/.bashrc

# if not running interactively, end
[[ $- != *i* ]] && return

alias b='bash'
alias bs='. ~/.bashrc'
alias v='vim'
alias vrc='v ~/.vimrc'
alias brc='v ~/.bashrc'
alias rm='rm -fr'

alias ls='ls --file-type --color=auto'
alias la='ls -A'
alias ll='ls -l'

# prompt
shopt -s autocd cdspell dirspell cdable_vars

prompt_command() {
  dir='~'
  [[ $PWD == $HOME ]] || dir="${PWD/$HOME\/}"
  branch=$(git branch 2>/dev/null)
  tag=$(git tag 2>/dev/null)

	[[ $EUID -eq 0 ]] && symbol='#' || symbol='$'
  
  timeStart=$(date +%s)


	((sec=(timeStart-timeEnd)%60))
	((min=(timeStart-timeEnd)%3600/60))
	((hr=(timeStart-timeEnd)/3600))

	unset timer
  (( $hr > 0 )) && timer=$(printf '\e[31m%s\e[0mh, ' "$hr")
  (( $min > 0 )) && timer+=$(printf '\e[33m%s\e[0mm, ' "$min")
  (( $sec > 0 )) && timer+=$(printf '\e[32m%s\e[0ms ' "$sec")
  
  [[ $timer ]] && timer="in $timer"

  timeEnd=$timeStart

  printf '%s \e[36m%s \e[0m%s %s\n' \
    "$dir" "${branch#* }" "$tag" "$timer"
}

PROMPT_COMMAND=prompt_command
timeEnd=$(date +%s)

PS1="\$([[ \$? -eq 0 ]] && printf '\[\e[32m\]%s\[\e[m\] ' "\$symbol" || \
  printf '\[\e[31m\]%s\[\e[0m\] ' "\$symbol")"

PS4='-[\e[33m${BASH_SOURCE/.sh}\e[0m: \e[32m${LINENO}\e[0m] '
PS4+='${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
