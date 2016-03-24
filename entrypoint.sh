#!/bin/bash

if [ "$1" != setup-workspace ] && [ -d /workspace -a ! -w /workspace ]; then
    # we need root privileges to change permission of the directory
    if ! sudo "$0" setup-workspace; then
        echo setup-workspace failed\; giving up.;
        exit 1;
    fi
fi

case "$1" in
    setup-workspace)
        # change permission; not recursive by purpose
        # recursive chown can take ages if the volume has a lot of files and directories
        chown migrator:migrator /workspace;
        exit
        ;;
    wait-up)
        # used when run from docker compose
        while :; do
            sleep 1;
        done
        ;;
    bash|/bin/bash)
        command=/bin/bash;
        ;;
    *)
        if which "$1" &>/dev/null; then
            command=$(which "$1");
        else
            echo "Command '$1' not found";
            exit 1;
        fi
        ;;
esac

# get rid of the first part ($1) which we already have in $command
shift;

exec "$command" "$@"

# vim: set tabstop=4 shiftwidth=4 expandtab :
