docker-moodle
=============

A Docker composition that installs and runs the latest Moodle 3.3 (stable)
release with an external MySQL or MariaDB database.  It automates the Moodle
set-up process using predefined default administrator credentials.

## Installation

```
git clone https://github.com/ellakcy/docker-moodle.git
cd docker-moodle
docker build -t moodle .
```

## Usage

To spawn a new instance of Moodle...

* ... using MySQL:

  ```
  docker run -d --name DB -e MYSQL_DATABASE=moodle -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -e MYSQL_USER=^a database user^ -e MYSQL_PASSWORD=^a database password^ mysql
  docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -p 8080:80 ellakcy/moodle
  ```

* ... using MariaDB:

  ```
  docker run -d --name DB -e MYSQL_DATABASE=^a database name^ -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -e MYSQL_USER=^a database user^ -e MYSQL_PASSWORD=^a database password^ mariadb
  docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -e MOODLE_DB_TYPE="mariadb" -p 8080:80 ellakcy/moodle
  ```

* ... using PostgreSQL:

  ```
  docker run --name=DB -e POSTGRES_USER=^a database user^ -e POSTGRES_PASSWORD=^a database password^ -e POSTGRES_DB=^a database name^ -d postgres
  docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -e MOODLE_DB_TYPE="pgsql" -p 8080:80 ellakcy/moodle
  ```

Then you can visit the following URL in a browser to get started:

```
http://0.0.0.0:8080
```

### Env vars

In addition to the SQL driver you can configure the Moodle installation
with the env vars listed below.   You can use these with the `-e` option
of `docker run`.

#### Default user

Variable Name | Default value | Description
---- | ------ | ------
`MOODLE_URL` | http://0.0.0.0 | The URL the site will be served from
`MOODLE_ADMIN` | *admin* | The default administrator's username
`MOODLE_ADMIN_PASSWORD` | *Admin~1234* | The default administrator's password - **CHANGE IN PRODUCTION*~
`MOODLE_ADMIN_EMAIL` | *admin@example.com* | The default dministrator's email

#### Database management

Variable Name | Default value | Description
---- | ------ | ------
`MOODLE_DB_TYPE` | *mysqli* | The type of database; one of: `mysqli`, `mariadb`, `pgsql`
`MOODLE_DB_HOST` | | The URL the database is hosted at
`MOODLE_DB_PASSWORD` | | Database user password
`MOODLE_DB_USER` | | Database username
`MOODLE_DB_NAME` | | Database name
`MOODLE_DB_PORT` | | The port the database can be accessed from

If any of these is left blank and the Moodle container is linked with a
database container, the correct parameters will be automatically detected
depending on the value of `MOODLE_DB_TYPE`.

### Volumes

* `/var/moodledata` – Moodle data directory

## Caveats

Support for the following is lacking:

* Moodle cronjobs (should be called from cron container)
* Log handling (stdout?)
* Email (does it even send?)

## Credits

This is a fork of [mhardison/docker-moodle](https://github.com/jmhardison/docker-moodle).
