#!/bin/bash

_msg(){ printf '[\e[32m>\e[m]: %s\n' "$1"; }

_warn(){ printf '[\e[33m>\e[m]: %s\n' "$1"; }

_fatal(){ printf '[\e[31m>\e[m]: %s\n' "$1"; exit 1; }

init_term(){
  shopt -s checkwinsize; (:;:)
  ((ROWS=LINES-1))

  printf '\e[?1049h\e[?25l\e[?7l'
}

deinit_term(){ printf '\e[?1049l\e[?25h\e[?7h'; }

sbar(){ printf '\e[%dH\e[2K\e[43;30mLytux\e[m %s' "$LINES" "$1"; }

getin(){ read -rsn 1 IN; [[ $IN == $'\e' ]]&& read -rsn 2 IN; IN="${IN,}"; }

draw_opts(){
  unset hoverHist i
  declare -gn opts="$1"

  printf '\e[2J\e[%dH' "$ROWS"
  printf '%s\n' "${opts[@]}"

  sbar "$2"
}

hover_opts(){
  (( PAUSE ))||{
    HOVER="${opts[cursor-LINES]% [✓✗]}"

    printf '\e[%dH\e[7m%s\e[m' "$cursor" "$HOVER"

    hoverHist+=("${cursor}H$HOVER")
    if (( ${i:=0} )); then
      printf '\e[%s' "${hoverHist[0]}"
      hoverHist=("${hoverHist[@]:1}")
    else i=1; fi
  }; PAUSE=0
}

scroll_opts(){
  if (( ${#opts[@]} > ROWS )); then
    if (( cursor > ROWS )); then
      cursor=1
      local popped=("${opts[@]:0:$ROWS}")
      opts=("${opts[@]:$ROWS}" "${popped[@]}")

      draw_opts
    elif (( cursor < 1 )); then
      cursor="$ROWS"
      local popped=("${opts[@]:(-$ROWS)}")
      opts=("${popped[@]}" "${opts[@]::${#opts[@]}-$ROWS}")
      
      draw_opts
    fi
  else
    if (( cursor > ROWS )); then
      ((cursor=ROWS-(${#opts[@]}-1)))
    elif (( cursor < ROWS-(${#opts[@]}-1) )); then
      cursor="$ROWS"
    fi
  fi
}

basic_keymap(){
  case $IN in
    q) deinit_term; exit;;
    j|\[B) ((cursor++));;
    k|\[A) ((cursor--));;
    *) false;;
  esac
}

select_opt(){
  local -n foo="$1" bar="$2"
  local baz="${1%O*}" i=0 n=0
  
  for _ in "${foo[@]}"; do
    case $_ in
      "$HOVER ✓") bar=0 foo[n]="$HOVER ✗";;
      "$HOVER ✗") bar=1 foo[n]="$HOVER ✓";;
      "$HOVER") bar=1 foo[n]="$HOVER ✓";;
    esac
    ((n++))
  done

  for _ in "${options[@]}"; do
    [[ $baz == "${_,}" ]]&& options[i]="$_ ✓"
    ((i++))
  done
}

update_opts(){
  cursor="$ROWS"

  if [[ $@ =~ ✓ ]]; then
    continue
  else
    local i=0

    for _ in "${options[@]}"; do
      [[ $_ == "$1 ✓" ]]&& options[i]="$1"
      ((i++))
    done
  fi
}
