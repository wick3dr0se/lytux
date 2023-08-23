#!/bin/bash

(( wifi ))||{
  sbar 'Scanning for wifi connections!'
  
  unset wifiOptions
  while read -r line; do
    [[ $line == '' ]]||{
      [[ ${wifiOptions[@]} =~ $line ]]|| wifiOptions+=("$line")
    }
  done < <(nmcli --colors=no -t -f SSID device wifi list)
}

draw_opts wifiOptions

cursor="$ROWS"

for((;;)){
  hover_opts

  getin
  
  basic_keymap||{
    case $IN in
      h|\[D)
        (( connected == 0 ))&& [[ $selectedWifi ]]&&{
          printf '\e[2J'
          sbar "Connecting to wireless network: $selectedWifi"
          nmcli device wifi connect "$selectedWifi"&& connected=1
        }

        update_opts 'wifi' "${wifiOptions[@]}"

        draw_opts options
        break
      ;;
      l|\[C)
        if (( wifi == 0 ))|| [[ ${opts[cursor-LINES]} == "$HOVER ✓" ]]; then
          select_opt wifiOptions wifi

          if (( wifi )); then
            selectedWifi="$HOVER"
            draw_opts wifiOptions "Wireless network $HOVER queued for connection!"
          else
            unset selectedWifi
            draw_opts wifiOptions "Deqeued $HOVER!"
          fi

        else
          draw_opts wifiOptions 'Select only one wireless network!'
        fi

      ;;
      *) PAUSE=1;;
    esac
  }
  scroll_opts
}