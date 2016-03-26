# docker-svn2git-workspace

Sets up a workspace, with the tools needed to migrate from Subversion to Git

The image from this repo can be obtained from docker hub using the tag
[`redmatter/svn2git-workspace`](https://hub.docker.com/r/redmatter/svn2git-workspace).

# How to use it?

Use the command below to start the container.

    docker run -d redmatter/svn2git-workspace --name svn2git \
        # specify a volume for the workspace
        [ -v workspace:/workspace ] \
        # specify an RSA SSH key for password-less interaction with svn and/or git
        [ -v ~/.ssh/id_rsa:/workspace/ssh-private-rsa.key ]

Now you can perform migration tasks, following instructions from [svn2git
documentation](https://github.com/nirvdrum/svn2git).
