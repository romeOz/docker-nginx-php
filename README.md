Installation
-------------------

 * [Install Docker](https://docs.docker.com/installation/) or [askubuntu](http://askubuntu.com/a/473720)
 * Pull the latest version of the image.
 
```bash
docker pull romeoz/docker-nginx-php
```

Alternately you can build the image yourself.

```bash
git clone https://github.com/romeoz/docker-nginx-php.git
cd docker-nginx-php
docker build -t="$USER/docker-nginx-php" .
```

Quick Start
-------------------

Run the application image:

```bash
docker run --name app -d -p 8080:80 romeoz/docker-nginx-php
```

The simplest way to login to the app container is to use the `docker exec` command to attach a new process to the running container.

```bash
docker exec -it app bash
```

Development/Persistence
-------------------

For development a volume should be mounted at `/var/www/app/`.

The updated run command looks like this.

```bash
docker run --name app -d -p 8080:80 \
  -v /host/to/path/app:/var/www/app/ \
  romeoz/docker-nginx-php
```

This will make the development.

Linked to other container
-------------------

As an example, will link with RDBMS PostgreSQL. 

```bash
docker run --name db -d romeoz/docker-postgresql
```

Run the application image:

```bash
docker run --name app -d -p 8080:80 \
  --link db:db \
  -v /host/to/path/app:/var/www/app/ \
  romeoz/docker-nginx-php
```

Upgrading
-------------------

To upgrade to newer releases, simply follow this 3 step upgrade procedure.

- **Step 1**: Stop the currently running image

```bash
docker stop app
```

- **Step 2**: Update the docker image.

```bash
docker pull romeoz/docker-nginx-php
```

- **Step 3**: Start the image

```bash
docker run --name app -d [OPTIONS] romeoz/docker-nginx-php
```

Out of the box
-------------------
 * Ubuntu 14.04.3 (LTS)
 * Nginx 1.8.0
 * PHP 5.6
 * Composer

License
-------------------

Nginx + PHP-FPM container image is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)