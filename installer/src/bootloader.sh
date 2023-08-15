#!/bin/bash

draw_opts bootloaderOptions

cursor="$ROWS"

for((;;)){
  hover_opts

  getin
  
  basic_keymap||{
    case $IN in
      h|\[D)
        update_opts 'Bootloader' "${bootloaderOptions[@]}"

        draw_opts options
        break
      ;;
      l|\[C)
        if (( bootloader == 0 ))|| [[ ${opts[cursor-LINES]} == "$HOVER ✓" ]]; then
          select_opt bootloaderOptions bootloader
          
          if (( bootloader )); then
            stagedPackages=("$HOVER" "${stagedPackages[@]}")
            draw_opts bootloaderOptions "$HOVER bootloader tool staged!"
          else
            stagedPackages=("${stagedPackages[@]:1}")
            draw_opts bootloaderOptions "Unstaged $HOVER!"
          fi

        else
          draw_opts bootloaderOptions 'Select only one bootloader tool!'
        fi

      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}
