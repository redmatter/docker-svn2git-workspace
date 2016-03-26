#!/bin/bash

: ${SSH_KEY:=$HOME/ssh-private-rsa.key}

# When mounting a volume; docker ( <= v1.10.3) does not provide means to set permissions on the mount point
# "setup-workspace" subcommand is a workaround for that
if [[ "$1" != setup-workspace && ( \
    ! -w $HOME || \
    ! -d $HOME/.ssh || \
    ( -f "${SSH_KEY}" && ! -f $HOME/.ssh/id_rsa )
) ]]; then
    # we need root privileges to change permission of the directory
    if ! sudo "$0" setup-workspace; then
        echo setup-workspace failed\; giving up.;
        exit 1;
    fi
fi

case "$1" in
    setup-workspace)
        if [ ! -w $HOME ]; then
            # change permission; not recursive by purpose
            # recursive chown can take ages if the volume has a lot of files and directories
            exec chown migrator:migrator $HOME;
        fi

        if [ ! -d $HOME/.ssh ]; then
            mkdir $HOME/.ssh &&
                chmod go-rwx $HOME/.ssh &&
                chown migrator:migrator $HOME/.ssh;
        fi

        if [[ -f "${SSH_KEY}" && ! -f $HOME/.ssh/id_rsa ]]; then
            cp "${SSH_KEY}" $HOME/.ssh/id_rsa &&
                chown migrator:migrator $HOME/.ssh/id_rsa &&
                chmod go-rwx $HOME/.ssh/id_rsa;
        fi
        ;;

    wait-up)
        # used when run from docker compose
        exec "/wait-up.sh";
        ;;

    bash|/bin/bash)
        ;;

    *)
        echo "Command '$1' unknown";
        exit 1;
        ;;
esac

# get rid of the first part ($1) which we already have in $command
shift;

exec /bin/bash "$@"

# vim: set tabstop=4 shiftwidth=4 expandtab :
