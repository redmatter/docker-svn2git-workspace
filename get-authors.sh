#!/usr/bin/env sh

REPO_URL=$1
EMAIL_DOMAIN=$2

if [ -z "$REPO_URL" ]; then
    echo "First argument must be the SVN repo"
    exit 1
fi

if [ -z "$EMAIL_DOMAIN" ]; then
    echo "Second argument must be email domain name"
    exit 1
fi

svn log --xml ${REPO_URL} | \
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
