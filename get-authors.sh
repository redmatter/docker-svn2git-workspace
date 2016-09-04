#!/usr/bin/env sh

usage() {
    SCRIPT_NAME=$(basename ${0})
    cat << EOF
NAME
   ${SCRIPT_NAME} - Generate a mapping of SVN to Git authors suitable for use as an 'authors' file with svn2git

SYNOPSIS
   ${SCRIPT_NAME} <repository-path> <email-domain-name> [svn-log args...]

OPTIONS
    <repository-path>
        The path to be used with svn log to obtain the list of authors.

    <email-domain-name>
        A domain name to be used when creating the email address for all authors.

    [svn-log-args...]
        Arguments which will be passed directly to the svn log command.

EXAMPLES
    ${SCRIPT_NAME} . acme.com > authors.txt
        Generate a mapping of authors for all commits on the current working copy, write it to authors.txt

    ${SCRIPT_NAME} svn+ssh://my.user@subversion.acme.com/trunk/my/repository/path acme.com -l100
        Generate a mapping of authors for the last 100 commits on the specified repository, display it on the console

EOF
}

if [ "${1}" = "help" ]; then
    usage
    exit 0
fi

if [ ${#} -lt 2 ]; then
    echo "Invalid usage\n"
    usage
    exit 1
fi

REPO_URL=$1 && shift
EMAIL_DOMAIN=$1 && shift
SVN_LOG_ARGS=$@

svn log --xml ${SVN_LOG_ARGS} ${REPO_URL} | \
# Extract the SVN usernames from the <author> XML tags
xmlstarlet sel -t -v '//author/text()' --nl - | \
# Sort and get only unique entries
sort -u | \
# Create a mapping for each username
while read USERNAME; do \
    EMAIL="${USERNAME}@${EMAIL_DOMAIN}" \
    # Split each section of a dot-separated username and capitalise the first letter
    NAME=$(echo ${USERNAME} | tr . ' ' | sed 's/\([a-z]\)\([^ ]*\)/\u\1\2/g')
    echo "${USERNAME} = ${NAME} <${EMAIL}>"
done
