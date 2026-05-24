#!/bin/bash
current_media_playing=$(playerctl status)
current_window_pid=$(xprop -root _NET_ACTIVE_WINDOW | cut -d' ' -f5| tail -n 1)
window_pid=$(xprop -id "$current_window_pid" _NET_WM_PID | cut -d '=' -f 2 | tr -d ' ')
process_name=$(ps -p "$window_pid" -o comm=) 
lock_screen(){
  betterlockscreen -l blur
}
playerctl_metadata(){
  echo $(playerctl metadata --format "$1")
}
application_pids(){
  echo $(playerctl metadata --format '{{ playerName }}' | xargs pgrep -f)
}
media_application_pids(){
  echo $(playerctl metadata --format '{{playerName}}' | xargs -r pgrep -f | grep -qx "$1" && echo true || echo false)
}
if [ "$current_media_playing" == "Playing" ]; then
  application=$(playerctl_metadata '{{playerName}}')
  exists=$(media_application_pids "$window_pid")
  if $exists;then
    media_title=$(playerctl_metadata '{{title}}')
    active_window_name=$(xprop -id $(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5) _NET_WM_NAME)
    if [[ "$active_window_name" == *"$media_title"* || "$active_window_name" == *"Picture-in-Picture"* ]];then
      echo "Laptop still active won't lock"
    else
      lock_screen
    fi
  else
    lock_screen
  fi
else
  lock_screen
fi

