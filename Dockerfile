FROM debian:jessie

MAINTAINER Dino.Korah@redmatter.com

ENV TZ="Europe/London" \
    EDITOR="/usr/bin/vim" \
    TERM="linux" \
    SHELL="/bin/bash" \
    HOME="/workspace"

COPY entrypoint.sh wait-up.sh /

RUN ( \
    export DEBIAN_FRONTEND=noninteractive; \
    export BUILD_DEPS=""; \
    export APP_DEPS="sudo openssh-client subversion git-core git-svn ruby rubygems vim-nox"; \

    set -e -u -x; \

    apt-get update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ${APP_DEPS} ${BUILD_DEPS}; \

    gem install svn2git; \

    apt-get remove -y $BUILD_DEPS; \
    apt-get clean autoclean; \
    apt-get autoremove --yes; \
    rm -rf /var/lib/{apt,dpkg,cache,log}/; \

    echo "migrator ALL=(ALL) NOPASSWD: /entrypoint.sh setup-workspace" > /etc/sudoers.d/migrator-setup-workspace; \

    mkdir $HOME; \
    useradd --shell $SHELL --home-dir $HOME migrator; \
)

USER migrator:migrator
WORKDIR $HOME
VOLUME $HOME

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bash" ]
