#!/usr/bin/env bash
#
# Performs setup tasks on container start

set -euo pipefail

# Copy Sourcebans sourcecode to docroot if empty
if [ -z "$(ls -A /var/www/html/)" ]; then
    cp -R /l4dstats/* /var/www/html/
fi


# Set directory owner for docroot recursively
chown -R www-data:www-data /var/www/html/

exec "docker-php-entrypoint" $@
