#!/bin/bash

echo "Installing moodle"

echo "Moving files into web folder"
rsync -rad --chown www-data:www-data /usr/src/moodle/ /var/www/html/

echo "Fixing files and permissions"
chown -R www-data:www-data /var/www/html
find /var/www/html -iname "*.php" | xargs chmod +x

echo "placeholder" > /var/moodledata/placeholder
chown -R www-data:www-data /var/moodledata
chmod 777 /var/moodledata

echo "Setting up database"

HAS_MySQL_SUPPORT=$(php -m | grep -i mysql | wc -w)
OK=0


if [ $HAS_MySQL_SUPPORT -gt 0 ]; then

  echo "Trying for mysql database"

  : ${MOODLE_DB_HOST:="moodle_db"}
  : ${MOODLE_DB_PORT:=3306}

    echo "Setting up the database connection info"
  : ${MOODLE_DB_USER:=${DB_ENV_MYSQL_USER:-root}}
  : ${MOODLE_DB_NAME:=${DB_ENV_MYSQL_DATABASE:-'moodle'}}

    if [ "$MOODLE_DB_USER" = 'root' ]; then
  : ${MOODLE_DB_PASSWORD:=$DB_ENV_MYSQL_ROOT_PASSWORD}
    else
  : ${MOODLE_DB_PASSWORD:=$DB_ENV_MYSQL_PASSWORD}
    fi

    echo "Checking if you can nonnect into database server ${MOODLE_DB_HOST}"
    while ! mysqladmin ping -h"$MOODLE_DB_HOST" -P $MOODLE_DB_PORT --silent; do
      echo "Connecting to ${MOODLE_DB_HOST} Failed"
      sleep 1
    done

    echo "Is ok? "$OK

    MOODLE_DB_TYPE=$(php /opt/detect_mariadb.php)
    echo "Database type: "${MOODLE_DB_TYPE}

# elif [ "$MOODLE_DB_TYPE" = "pgsql" ]; then
#
#   : ${MOODLE_DB_HOST:=$DB_PORT_5432_TCP_ADDR}
#   : ${MOODLE_DB_PORT:=${DB_PORT_5432_TCP_PORT}}
#
#     echo "Setting up the database connection info"
#
#   : ${MOODLE_DB_NAME:=${DB_ENV_POSTGRES_DB:-'moodle'}}
#   : ${MOODLE_DB_USER:=${DB_ENV_POSTGRES_USER}}
#   : ${MOODLE_DB_PASSWORD:=$DB_ENV_POSTGRES_PASSWORD}

else
  echo >&2 "No database support found"
  exit 1
fi

# HAS_POSTGRES_SUPPORT=

if [ -z "$MOODLE_DB_PASSWORD" ]; then
  echo >&2 'error: missing required MOODLE_DB_PASSWORD environment variable'
  echo >&2 '  Did you forget to -e MOODLE_DB_PASSWORD=... ?'
  echo >&2
  exit 1
fi

echo "Installing moodle"
MOODLE_DB_TYPE=$MOODLE_DB_TYPE php /var/www/html/admin/cli/install_database.php \
          --adminemail=${MOODLE_ADMIN_EMAIL} \
          --adminuser=${MOODLE_ADMIN} \
          --adminpass=${MOODLE_ADMIN_PASSWORD} \
          --agree-license

MOODLE_DB_TYPE=$MOODLE_DB_TYPE exec "$@"
