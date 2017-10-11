docker-moodle
=============

A Docker image that installs and runs the latest Moodle 3.1 stable, with external MySQL, Mariadb or Postgresql Database and automated installation with a default predefined administrator user.

## Buidling

```
git clone https://github.com/ellakcy/docker-moodle.git
cd docker-moodle
docker-compose build --no-cache --force-rm .
```

The build will produce the following images for now all images are running apache ang php7.0:

* `ellakcy/moodle:apache_base` : A base image over apache, where you just can base your own moodle image for the database you want.
* `ellakcy/moodle:mysql_maria_apache`: An Image where provides moodle installation supporting mysql or mariadb.
* `ellakcy/moodle:postgresql_apache`:  An Image where provides moodle installation supporting postgresql.
* `ellakcy/moodle:mysql_maria_fpm_alpine`: An alpine based image using fpm supporting mysql and mariadb.
* `ellakcy/moodle:alpine_fpm_base`: A base image over alpine and fpm, where you just can base your own moodle image for the database you want.

## Run

### Manually

#### Apache based solutions

To spawn a new instance of Moodle:

* Using mysql:

```
docker run -d --name DB -e MYSQL_DATABASE=moodle -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -e MYSQL_USER=^a database user^ -e MYSQL_PASSWORD=^a database password^ mysql
docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -p 8080:80 ellakcy/moodle:mysql_maria_apache
```

* Using mariadb:

```
docker run -d --name DB -e MYSQL_DATABASE=^a database name^ -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -e MYSQL_USER=^a database user^ -e MYSQL_PASSWORD=^a database password^ mariadb
docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -e MOODLE_DB_TYPE="mariadb" -p 8080:80 ellakcy/moodle:mysql_maria_apache
```

* Using postgresql

```
docker run --name=DB -e POSTGRES_USER=^a database user^ -e POSTGRES_PASSWORD=^a database password^ -e POSTGRES_DB=^a database name^ -d postgres
docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -e MOODLE_DB_TYPE="pgsql" -p 8080:80 ellakcy/moodle:postgresql_apache
```

Then you can visit the following URL in a browser to get started:

```
http://0.0.0.0:8080

```

### Alpine and Fpm based solutions

For fpm solutions is recomended to use docker-compose.

### Via docker-compose

#### All available images and varieties

You can run all build containers of this repo via:

```bash
docker compose up
```

For production is recomended to create your own `docker-compose.yml` file and provide your own settings.

#### Apache based solutions

* Mysql variant

You can run all build containers of this repo via:

```bash
docker compose up moodle_mysql moodle_mysql_db
```

* Mariadb variant (uses the very same image)

```bash
docker compose up moodle_maria_db moodle_maria
```

* Postgresql variant

```bash
docker compose up moodle_psql_db moodle_psql
```

For production is recomended to create your own `docker-compose.yml` file and provide your own settings.

#### Alpine with fpm based solutions

* Mysql variant

```bash
docker-compose up nginx_mysql moodle_mysql_alpine_db moodle_alpine_fpm_mysql
```

* Mariadb variant

```bash
docker-compose up nginx_maria moodle_mariadb_alpine_db moodle_alpine_fpm_mariadb
```

## Enviromental variables

Also you can use the following extra enviromental variables (using `-e` option on `docker run` command):

### Enviromental Variables for Default user settings:

Variable Name | Default value | Description
---- | ------ | ------
**MOODLE_URL** | http://0.0.0.0 | The url of the site that moodle is setup
**MOODLE_ADMIN** | *admin* | The default administrator's username
**MOODLE_ADMIN_PASSWORD** | *Admin~1234* | The administrator's default password. *PLEASE DO CHANGE ON PRODUCTION*
**MOODLE_ADMIN_EMAIL** | *admin@example.com* | Administrator's default email.

### Enviromental Variables for Database settings:

Variable Name | Default value | Description
---- | ------ | ------
**MOODLE_DB_HOST** | | The url that the database is accessible
**MOODLE_DB_PASSWORD** | | The password for the database
**MOODLE_DB_USER** | | The username of the database
**MOODLE_DB_NAME** | | The database name
**MOODLE_DB_PORT** | | The port that the database is accessible

If no value specified and the the container that runs the current docker image is conencted to another database container then depending the value of `MOODLE_DB_TYPE` it will autodetect the correct parameters.


### Volumes

For now you can use the following volumes:

* **/var/moodledata** In order to get all the stored  data.


## Caveats
The following aren't handled, considered, or need work:
* moodle cronjob (should be called from cron container)
* log handling (stdout?)
* email (does it even send?)

## Credits

This is a fork of JmHardison  (https://github.com/jmhardison/docker-moodle)'s Dockerfile.
