FROM ubuntu:precise
MAINTAINER romeOz <serggalka@gmail.com>

ENV PHP_VERSION=5.4 \
	APP_LOCALE="en_US.UTF-8"
RUN locale-gen ${APP_LOCALE}
ENV LANG ${APP_LOCALE}
ENV LANGUAGE en_US:en
ENV LC_ALL ${APP_LOCALE}

# Add playbooks to the Docker image
ADD ./app /var/www/app/
ADD ./provisioning /tmp/provisioning/
ADD ./supervisord.conf /etc/supervisor/conf.d/
WORKDIR /tmp/provisioning/

RUN	\
	# Install ansible
	apt-get update \
	&& apt-get install --no-install-recommends -y software-properties-common python-software-properties sudo \
	&& add-apt-repository -y ppa:ansible/ansible \
	&& apt-get update \
	&& apt-get install -y ansible \
	# Apply playbooks
	&& ansible-playbook -v docker.yml -i 'docker,' -c local --extra-vars "php_version=${PHP_VERSION}" \
	# Install supervisor
	&& apt-get install -y supervisor && mkdir -p /var/log/supervisor \
	# Cleaning
	&& apt-get purge -y ansible \
	&& apt-get autoremove -y \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/provisionin* \
	# Forward request and error logs to docker log collector
 	&& ln -sf /dev/stdout /var/log/nginx/access.log \
 	&& ln -sf /dev/stdout /var/log/php5-fpm.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /var/www/app/

EXPOSE 80 433

CMD ["/usr/bin/supervisord"]