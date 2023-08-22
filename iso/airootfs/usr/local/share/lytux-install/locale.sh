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
        if (( locale == 0 ))|| [[ ${opts[cursor-LINES]} == "$HOVER ✓" ]]; then
          select_opt localeOptions locale

          if (( locale )); then
            selectedLocale="$HOVER"
            draw_opts localeOptions "Locale $HOVER queued!"
          else
            unset selectedLocale
            draw_opts localeOptions "Deqeued $HOVER!"
          fi

        else
          draw_opts localeOptions 'Select only one locale!'
        fi

      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}