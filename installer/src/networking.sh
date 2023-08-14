#!/bin/bash

draw_opts networkingOptions

cursor="$ROWS"

for((;;)){
  hover_opts
  
  getin
  
  basic_keymap||{
    case $IN in
      h|\[D)
        update_opts 'Networking' "${networkingOptions[@]}"
        
        draw_opts options
        break
      ;;
      l|\[C)        
        select_opt networkingOptions stagedPackages
        
        if (( selected )); then
          draw_opts networkingOptions "Staged $HOVER for install!"
        else
          draw_opts networkingOptions "Unstaged $HOVER!"
        fi
      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}
