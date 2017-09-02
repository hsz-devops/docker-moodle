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
echo $HAS_MySQL_SUPPORT

if [ $HAS_MySQL_SUPPORT -gt 0 ]; then

  echo "Trying for mysql database"

  : ${MOODLE_DB_HOST:=$DB_PORT_3306_TCP_ADDR}
  : ${MOODLE_DB_PORT:=${DB_PORT_3306_TCP_PORT}}

    echo "Setting up the database connection info"
  : ${MOODLE_DB_USER:=${DB_ENV_MYSQL_USER:-root}}
  : ${MOODLE_DB_NAME:=${DB_ENV_MYSQL_DATABASE:-'moodle'}}

    if [ "$MOODLE_DB_USER" = 'root' ]; then
  : ${MOODLE_DB_PASSWORD:=$DB_ENV_MYSQL_ROOT_PASSWORD}
    else
  : ${MOODLE_DB_PASSWORD:=$DB_ENV_MYSQL_PASSWORD}
    fi


    for count in {1..10}; do
      if [ $(nc -z ${MOODLE_DB_HOST} ${MOODLE_DB_PORT}) ]; then
        OK=1
        break
      fi
    done

    if [ $OK -eq 1 ]; then
      MOODLE_DB_TYPE=$(php /opt/detect_mariadb.php)
      echo "DB Type: "${MOODLE_DB_TYPE}
    fi

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

# else
#   echo >&2 "This database type is not supported"
#   echo >&2 "Did you forget to -e MOODLE_DB_TYPE='mysqli' ^OR^ -e MOODLE_DB_TYPE='mariadb' ^OR^ -e MOODLE_DB_TYPE='pgsql' ?"
#   exit 1
fi

# HAS_POSTGRES_SUPPORT=

if [ -z "$MOODLE_DB_PASSWORD" ]; then
  echo >&2 'error: missing required MOODLE_DB_PASSWORD environment variable'
  echo >&2 '  Did you forget to -e MOODLE_DB_PASSWORD=... ?'
  echo >&2
  exit 1
fi

echo "Installing moodle"
php /var/www/html/admin/cli/install_database.php \
          --adminemail=${MOODLE_ADMIN_EMAIL} \
          --adminuser=${MOODLE_ADMIN} \
          --adminpass=${MOODLE_ADMIN_PASSWORD} \
          --agree-license

MOODLE_DB_TYPE exec "$@"
