#!/bin/bash

running=1

handle_signal() {
    echo Trapped signal\; stopping...
    running=0
}

trap handle_signal SIGKILL SIGTERM SIGHUP SIGINT

while [ $running -eq 1 ]; do
    sleep 1;
done
