# docker-svn2git-workspace

Sets up a workspace, with the tools needed to migrate from Subversion to Git

The image from this repo can be obtained from docker hub using the tag
[`redmatter/svn2git-workspace`](https://hub.docker.com/r/redmatter/svn2git-workspace).

# How to use it?

Use the command below to run the container:

    docker run -it --rm -v /host/path/to/workspace:/workspace redmatter/svn2git-workspace

This allows you to use svn2git, though if need to use SSH for SVN or Git then you'll need to either pass in your
private key or pass in your SSH agent.  To pass in your private key:

    docker run -it --rm -v /host/path/to/workspace:/workspace -v ~/.ssh/id_rsa:/root/.ssh/id_rsa redmatter/svn2git-workspace

The provided `docker-compose.yml` contains all the configuration needed to pass in your SSH agent:

    docker-compose run --rm svn2git

Once in the container, you can use the `get-authors.sh` script to populate a file with a mapping of SVN users to Git
users:

    get-authors.sh <svn+ssh://host/path/to/trunk> <email-domain.com> [custom-authors-path.txt]

This will map SVN users to Git users as follows:

    first.last = First last <first.last@${EMAIL_DOMAIN}>
    name = Name <name@${EMAIL_DOMAIN}>

Now you can perform migration tasks, following instructions from [svn2git
documentation](https://github.com/nirvdrum/svn2git).
