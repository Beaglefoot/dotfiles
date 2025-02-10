#!/bin/bash

function usage() {
    printf "\n"
    printf "Usage: %s [OPTIONS] NUMBER[SUFFIX]\n\n" $(basename $0)
    printf "For possible NUMBER and SUFFIX values check help for sleep command.\n\n"
    printf "OPTIONS:\n"
    printf "\t%s\t\t%s\n" "-h|--help" "Show this help message"
    printf "\n"
}

function validate_wait_time() {
    local wait_time="$1"

    [[ "$wait_time" =~ ^[0-9]+$ || "$wait_time" =~ [0-9]+[hms] ]] || { usage >&2; exit 2; }
}

function time2seconds() {
    local time_string="$1"

    if [[ "$time_string" =~ ^[0-9]+$ ]]; then
        echo $time_string
    else
        echo $time_string | gawk '
            { match($0, /([0-9]+h)?\s?([0-9]+m)?\s?([0-9]+s)?/, tp) }
            END { print tp[1] * 3600 + tp[2] * 60 + tp[3] }
        '
    fi
}

function humanize_duration() {
    local total_seconds=$1
    local hours=$(( $total_seconds / 3600 ))
    local minutes=$(( ($total_seconds - $hours * 3600) / 60 ))
    local seconds=$(( $total_seconds % 60 ))

    printf "%02d:%02d:%02d" ${hours} ${minutes} ${seconds}
}

function clear_line() {
    echo -ne "\033[K"
}

function notify() {
    local text="$1"
    local script_name=$(basename "$0")
    local notification_timeout_ms=600000

    if [[ "$OSTYPE" == "darwin"* ]]; then
        osascript -e "display notification \"$text\" with title \"$script_name\""
    else
        notify-send -t ${notification_timeout_ms} "$text"
    fi
}


while getopts ':h' OPTION; do
    case $OPTION in
        h | ?)
            usage >&2
            exit $([[ $OPTION == "h" ]] && echo 0 || echo 2)
            ;;
    esac
done

shift $(($OPTIND - 1))

WAIT_TIME="$*"

validate_wait_time "$WAIT_TIME"

WAIT_SECONDS=$(time2seconds "$WAIT_TIME")
BREAKS_COUNT=1

echo

while true; do
    clear_line

    echo -ne "\r($BREAKS_COUNT) Next break in: $(humanize_duration $WAIT_SECONDS)"

    if [[ $WAIT_SECONDS == 0 ]]; then
        notify "Break may be?"
        echo
        (( BREAKS_COUNT++ ))
        WAIT_SECONDS=$(time2seconds $WAIT_TIME)
        continue
    fi

    sleep 1
    (( WAIT_SECONDS-- ))
done
