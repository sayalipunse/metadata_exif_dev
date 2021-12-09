#!/usr/bin/env bash

# Exit if any of the intermediate steps fail
set -e

# Extract "url" and "destination_filename" arguments from the input into
# url and destination_filename shell variables.
# jq will ensure that the values are properly quoted
# and escaped for consumption by the shell.
eval "$(jq -r '@sh "url=\(.url) destination_filename=\(.destination_filename)"')"

# To download image and store in the destination
curl -L $url -o $destination_filename 2>&1 | logger -t download_image

echo "{\"file\" : \"$destination_filename\",\"success\" : \"$?\"}"
