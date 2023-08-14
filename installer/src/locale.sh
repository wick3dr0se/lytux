#!/bin/bash

draw_opts localeOptions

cursor="$ROWS"

for((;;)){
  hover_opts

  getin
  
  basic_keymap||{
    case $IN in
      h|\[D)
        update_opts 'Locale' "${localeOptions[@]}"

        draw_opts options
        break
      ;;
      l|\[C)
        
        select_opt localeOptions selectedLocales
        
        if (( selected )); then
          draw_opts localeOptions "Queued $HOVER locale for generation!"
        else
          draw_opts localeOptions "Deqeued $HOVER!"
        fi
      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}
