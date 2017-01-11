# docker-svn2git-workspace

Sets up a workspace, with the tools needed to migrate from Subversion to Git

The image from this repo can be obtained from docker hub using the tag
[`redmatter/svn2git-workspace`](https://hub.docker.com/r/redmatter/svn2git-workspace).

# How to use it?

Use the command below to run the container:

    docker run -it --rm -v /host/path/to/workspace:/workspace redmatter/svn2git-workspace

This allows you to use svn2git, though if need to use SSH for SVN or Git then you'll need to either pass in your
private key or pass in your SSH agent.

## Private Key

To pass in your private key:

    docker run -it --rm -v /host/path/to/workspace:/workspace -v ~/.ssh/id_rsa:/root/.ssh/id_rsa redmatter/svn2git-workspace

If you are unable to connect to your SVN repository it could be because the private key has the wrong permissions; you'll
need to ensure the file is owned by the user which the container is running as:

    chown root:root ~/.ssh/id_rsa

To avoid modifying the key on the host, you may prefer to mount the key into a temporary location and copy it from there to
`~/.ssh/id_rsa` before changing its ownership.

## SSH Agent

The provided `docker-compose.yml` contains all the configuration needed to pass in your SSH agent:

    docker-compose run --rm svn2git

## Define the author mapping

Once in the container, you can use the `get-authors` script to populate a file with a mapping of SVN users to Git
users:

    get-authors <svn+ssh://host/path/to/trunk> <email-domain.com> > authors.txt

This will map SVN users to Git users as follows:

    name = Name <name@${EMAIL_DOMAIN}>
    first.last = First Last <first.last@${EMAIL_DOMAIN}>
    first.middle.last = First Middle Last <first.middle.last@${EMAIL_DOMAIN}>
    etc...

## Migrate

Now you can perform migration tasks, following instructions from [svn2git
documentation](https://github.com/nirvdrum/svn2git).
