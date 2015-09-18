FROM ubuntu:trusty
MAINTAINER romeOz <serggalka@gmail.com>

ENV APP_LOCALE="en_US.UTF-8"
RUN locale-gen ${APP_LOCALE}
ENV LANG ${APP_LOCALE}
ENV	LANGUAGE en_US:en
ENV	LC_ALL ${APP_LOCALE}

# Add playbooks to the Docker image
ADD ./app /var/www/app/
ADD ./provisioning /tmp/provisioning/
ADD supervisord.conf /etc/supervisor/conf.d/
WORKDIR /tmp/provisioning/

RUN	\
	# Install ansible
	apt-get -y update \
	&& apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev \
	&& pip install https://pypi.python.org/packages/source/a/ansible/ansible-1.9.3.tar.gz \
	# Apply playbooks
	&& ansible-playbook -v docker.yml -i 'docker,' -c local \
	# Install supervisor
	&& apt-get install -y supervisor && mkdir -p /var/log/supervisory \
	# Cleaning
	&& pip uninstall -y ansible \
	&& apt-get purge -y build-essential software-properties-common python-software-properties git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /tmp/provisionin* \
	# forward request and error logs to docker log collector
 	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

WORKDIR /var/www/app/

EXPOSE 80 433

CMD ["/usr/bin/supervisord"]