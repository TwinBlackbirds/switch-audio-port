#!/usr/bin/bash
# get the currently active device's info, find the name of the port in use
ACTIVE_PORT=$(pactl list sinks | awk -v sink_name="$(pactl get-default-sink)" '
  $1 == "Name:" && $2 == sink_name {found=1}
  found && /^$/ {exit}
  found {print}
' | grep 'Active Port')

# switch the port to the opposite one (if possible)
if [[ "$ACTIVE_PORT" == *"analog-output-lineout" ]]; then
    # echo "LINEOUT"
    pactl set-sink-port @DEFAULT_SINK@ analog-output-headphones
elif [[ "$ACTIVE_PORT" == *"analog-output-headphones" ]]; then 
    # echo "HEADPHONES"
    pactl set-sink-port @DEFAULT_SINK@ analog-output-lineout
else 
    echo "UNKNOWN DEVICE IN USE!"
    return 1;
fi  
