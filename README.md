docker-moodle
=============

A Docker image that installs and runs the latest Moodle 3.1 stable, with external MySQL/Mariadb Database and automatic installation with a default predefined administrator user.

## Buidling

```
git clone https://github.com/ellakcy/docker-moodle.git
cd docker-moodle
docker build -t moodle .
```

The build will produce the following images for now all images are running apache ang php7.0:

* `ellakcy/moodle:apache_base` : A base Image where you just can base your own moodle image for the database you want.
* `ellakcy/moodle:mysql_maria_apache`: An Image where provides moodle installation supporting mysql or mariadb.
* `ellakcy/moodle:postgresql_apache`:  An Image where provides moodle installation supporting postgresql.


## Run

### Manually

To spawn a new instance of Moodle:

* ... using MySQL:

```
docker run -d --name DB -e MYSQL_DATABASE=moodle -e MYSQL_RANDOM_ROOT_PASSWORD=yes -e MYSQL_ONETIME_PASSWORD=yes -e MYSQL_USER=^a database user^ -e MYSQL_PASSWORD=^a database password^ mysql
docker run -d -P --name moodle --link DB:DB -e MOODLE_URL=http://0.0.0.0:8080 -p 8080:80 ellakcy/moodle:mysql_maria_apache
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

### Via docker-compose

You can run all build containers of this repo via:

```bash
docker compose up
```

For production is recomended to create your own `docker-compose.yml` file and provide your own settings. 


## Enviromental variables

Also you can use the following extra enviromental variables (using `-e` option on `docker run` command):

### Enviromental Variables for Default user settings:

Variable Name | Default value | Description
---- | ------ | ------
`MOODLE_URL` | http://0.0.0.0 | The URL the site will be served from
`MOODLE_ADMIN` | *admin* | The default administrator's username
`MOODLE_ADMIN_PASSWORD` | *Admin~1234* | The default administrator's password - **CHANGE IN PRODUCTION*~
`MOODLE_ADMIN_EMAIL` | *admin@example.com* | The default dministrator's email

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

This is a fork of [mhardison/docker-moodle](https://github.com/jmhardison/docker-moodle).
