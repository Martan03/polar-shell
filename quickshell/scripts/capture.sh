#!/usr/bin/bash

set -e

ACTION=$1
shift

MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')
FORMAT="mp4"
CLEAN_DESKTOP=false
DELAY=0

OUTPUT_DIR="$HOME/Videos"

function fail() {
	echo -e "\x1b[91mError:\x1b[0m $1" >&2
	exit 1
}

# Sets the hyprland config to have no window gaps, no border and no rounding.
function set_clean_desktop() {
    config="{
    general = {
        gaps_out = 0,
        gaps_in = 0,
        border_size = 0
    },
    decoration = { rounding = 0 }
}"
    hyprctl --instance 0 eval "hl.config($config)"
}

function print_help() {
    echo "Usage: $0 start|stop [- monitor] [-f format] [-c] [-d delay]"
}

while getopts ":m:f:cd:" opt; do
    case $opt in
        m) MONITOR="$OPTARG" ;;
        f) FORMAT="$OPTARG" ;;
        c) CLEAN_DESKTOP=true ;;
        d) DELAY="$OPTARG" ;;
        \?) fail "unknown argument '-$OPTARG'" ;;
        :) fail "argument '-$OPTARG' requires a value" ;;
    esac
done

PID_FILE="/tmp/quickshell_capture.pid"
RAW_FILE="/tmp/quickshell_raw_capture.$FORMAT"

if [ "$ACTION" = "start" ]; then
    if [ "$DELAY" -gt 0 ]; then
        sleep "$DELAY"
    fi

    if [ "$CLEAN_DESKTOP" = true ]; then
        set_clean_desktop
    fi

    setsid wf-recorder --output "$MONITOR" \
        -f "$RAW_FILE" \
        -c libx264rgb \
        -p preset=ultrafast >/dev/null 2>&1 &
    echo $! > "$PID_FILE"
elif [ "$ACTION" = "stop" ]; then
    if [ -f "$PID_FILE" ]; then
        kill -SIGINT $(cat "$PID_FILE")
        rm "$PID_FILE"

        sleep 0.5
        FILENAME="$OUTPUT_DIR/Capture_$(date +%Y%m%d_%H%M%S).$FORMAT"
        DURATION=$(ffprobe -v error -show_entries format=duration \
            -of default=noprint_wrappers=1:nokey=1 "$RAW_FILE")

        NEW_DURATION=$(awk "BEGIN {print $DURATION - 0.6}")
        ffmpeg -y -ss 0 -t "$NEW_DURATION" -i $RAW_FILE -c \
            copy "$FILENAME" >/dev/null 2>&1

        rm "$RAW_FILE"
    fi

    hyprctl reload
elif [ "$ACTION" = "running" ]; then
    if [ -f "$PID_FILE" ]; then
        echo "true"
    else
        echo "false"
    fi
elif [[ "$ACTION" = "-h" || "$ACTION" = "--help" ]]; then
    print_help
else
    fail "unknown action '$ACTION'"
fi
