#!/bin/bash

function get_jack_status() {
    jack_control status | tail -n 1
}


if [[ $(get_jack_status) == "started" ]]; then
    notify-send "Jack is already started"
    exit 0
fi


jack_control start && pulseaudio -k

notify-send "Jack status: $(get_jack_status)"
