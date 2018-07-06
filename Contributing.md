# Notes for Contributors
First of all thank you for providing a helping hand into out efforts.

## Docker files
As you noticed there are 2 `docker-compose.yml` files:

* The normal `docker-compose.yml` that is used for buidling the images
* Τhe `docker-compose-ssl-reverse-nginx.yml` used for testing the moodle's behavior againist a nginx reverse proxy.

## Something wrong happens during container launch:
Then run the following commands:

```
docker-compose -f docker-compose-ssl-reverse-nginx.yml down -v --remove-orphans
docker-compose down -v --remove-orphans
```
## Ressetting the installation
Run the same commands as above.
