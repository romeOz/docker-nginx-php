FROM romeoz/docker-phpfpm:5.4
MAINTAINER romeOz <serggalka@gmail.com>

ENV OS_LOCALE="en_US.UTF-8"
RUN locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE} \
	LANGUAGE=en_US:en \
	LC_ALL=${OS_LOCALE}

COPY ./supervisord.conf /etc/supervisor/conf.d/
COPY ./app /var/www/app/

RUN	\
	buildDeps='software-properties-common python-software-properties' \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y $buildDeps \
	&& add-apt-repository -y ppa:nginx/stable \
	&& apt-get update \
	&& apt-get install -y nginx \
	&& rm -rf  /etc/nginx/sites-enabled/* /etc/nginx/sites-available/* \
	# Install composer
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
	# Install supervisor
	&& apt-get install -y supervisor && mkdir -p /var/log/supervisor \
	&& chown www-data:www-data /var/www/app/ -Rf \
	# Cleaning
	&& apt-get purge -y --auto-remove $buildDeps \
	&& apt-get autoremove -y && apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	# Forward request and error logs to docker log collector
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY ./configs/nginx.conf /etc/nginx/nginx.conf
COPY ./configs/app.conf /etc/nginx/sites-enabled/app.conf
COPY ./configs/www.conf /etc/php5/fpm/pool.d/www.conf

WORKDIR /var/www/app/

EXPOSE 80 433

CMD ["/usr/bin/supervisord"]