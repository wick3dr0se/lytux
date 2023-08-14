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
        is_selected stagedPackages&& continue
        
        select_opt bootloaderOptions stagedPackages

        if (( selected )); then
          draw_opts bootloaderOptions "Staged $HOVER bootloader for install!"
        else
          draw_opts bootloaderOptions "Unstaged "$HOVER"!"
        fi
      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}
