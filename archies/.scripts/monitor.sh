#!/bin/bash

# Initial state
prev_state=""

while true; do
    # Get the current state of connected monitors
    current_state=$(xrandr --query | grep " connected")

    # Compare with previous state
    if [ "$current_state" != "$prev_state" ]; then
        # Log the change
        logger "Monitor configuration change detected"

        # Update the previous state
        prev_state="$current_state"

        ~/.scripts/monitor_manager 
    fi

    # Sleep for a while before checking again
    sleep 2
done
