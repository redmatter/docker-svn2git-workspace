#!/usr/bin/env sh

REPO_URL=$1
OUTPUT_PATH=${2:-authors.txt}

EMAIL_DOMAIN="redmatter.com"
svn log ${REPO_URL} --xml | grep '<author>' | sort -u > "${OUTPUT_PATH}"

# Deal with the standard case, where a username is defined as firstname.lastname
# Translate `<author>first.last</author>` into `first.last = first last <first.last@${EMAIL_DOMAIN}`
sed -r "s#.*>(.+)\.(.+)<.*#\1.\2 = \1 \2 <\1.\2\@${EMAIL_DOMAIN}>#" -i "${OUTPUT_PATH}"

# Deal with situations where there's only a single name, no dot separator
# Translate `<author>name</author>` into `name = name <name@${EMAIL_DOMAIN}`
sed -r "s#.*>(.+)<.*#\1 = \1 <\1@${EMAIL_DOMAIN}>#" -i "${OUTPUT_PATH}"

# Capitalise the first name
# Before: `first.last = first last <first.last@${EMAIL_DOMAIN}``
# After:  `first.last = First last <first.last@${EMAIL_DOMAIN}`
# Before: `name = name <name@${EMAIL_DOMAIN}`
# After:  `name = Name <name@${EMAIL_DOMAIN}`
sed -r -e 's/(^.+= )(.)/\1\u\2/g' -i "${OUTPUT_PATH}"

# Capitalise the last name
# Before: `first.last = First last <first.last@${EMAIL_DOMAIN}`
# After:  `first.last = First Last <first.last@${EMAIL_DOMAIN}`
sed -r -e 's/(^.+ )(.+ <.+)/\1\u\2/g' -i "${OUTPUT_PATH}"

echo "Authors scraped from svn log and stored in ${OUTPUT_PATH}:"
echo "----------------------------------------------------------------------------------------------"
cat ${OUTPUT_PATH}
echo "----------------------------------------------------------------------------------------------"
echo "Check the usernames, names and email addresses are correct before using this file with svn2git"
