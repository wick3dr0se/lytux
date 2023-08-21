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
        if (( networking == 0 ))|| [[ ${opts[cursor-LINES]} == "$HOVER ✓" ]]; then
          select_opt networkingOptions networking
          
          if (( networking )); then
            installPackages=("${HOVER% *}" "${installPackages[@]}")
            draw_opts networkingOptions "${HOVER% *} networking tool staged!"
          else
            installPackages=("${installPackages[@]:1}")
            draw_opts networkingOptions "Unstaged ${HOVER% *}!"
          fi

        else
          draw_opts networkingOptions 'Select only one networking tool!'
        fi

      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}
