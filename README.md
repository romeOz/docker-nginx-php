Table of Contents
-------------------

 * [Installation](#installation)
 * [Quick Start](#quick-start)
 * [Persistence](#development-persistence)
 * [Linked to other container](#linked-to-other-container)
 * [Logging](#logging)
 * [Upgrading](#upgrading)
 * [Out of the box](#out-of-the-box)

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

Logging
-------------------

All the logs are forwarded to stdout and sterr. You have use the command `docker logs`.

```bash
docker logs app

```

####Split the logs

You can then simply split the stdout & stderr of the container by piping the separate streams and send them to files:

```bash
docker logs app > stdout.log 2>stderr.log
cat stdout.log
cat stderr.log
```

or split stdout and error to host stdout:

```bash
docker logs app > -
docker logs app 2> -
```

####Rotate logs

Create the file /etc/logrotate.d/docker-containers with the following text inside:

```
/var/lib/docker/containers/*/*.log {
    rotate 31
    daily
    nocompress
    missingok
    notifempty
    copytruncate
}
```
> Optionally, you can replace `nocompress` to `compress` and change the number of days.

Out of the box
-------------------
 * Ubuntu 14.04.3 (LTS)
 * Nginx 1.8.0
 * PHP 5.6
 * Composer

License
-------------------

Nginx + PHP-FPM container image is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)