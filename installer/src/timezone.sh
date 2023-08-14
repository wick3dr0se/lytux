#!/bin/bash

draw_opts timezoneOptions

cursor="$ROWS"

for((;;)){
  hover_opts
  
  getin
  
  basic_keymap||{
    case $IN in
      h|\[D)
        update_opts 'Timezone' "${timezoneOptions[@]}"

        draw_opts options
        break
      ;;
      l|\[C)    
        select_opt timezoneOptions selectedTimezones
        
        if (( selected )); then
          draw_opts timezoneOptions "Timezone $HOVER queued!"
        else
          draw_opts timezoneOptions "Deqeued $HOVER!"
        fi
      ;;
      *) PAUSE=1;;
    esac
  }

  scroll_opts
}
