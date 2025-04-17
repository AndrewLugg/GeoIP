FROM php:8.4-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

# Install GeoIP PHP extension.
RUN apt-get update
RUN apt-get install -y libmaxminddb-dev wget cron unzip vim
RUN pecl install maxminddb
RUN install-php-extensions zip xmlrpc
RUN curl -L -s $(curl -L -s https://api.github.com/repos/maxmind/geoipupdate/releases/latest | grep -o -E "https://(.*)geoipupdate_(.*)_linux_amd64.deb") --output geoip-update.deb

#Arbitary time, just something random once per day.
RUN (crontab -l ; echo "05 23 * * * /usr/bin/geoipupdate -v >> /proc/1/fd/1 2>&1") | crontab

RUN dpkg -i geoip-update.deb

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod o+x /root/entrypoint.sh

RUN a2enmod rewrite expires
ADD .htaccess /var/www/html/.htaccess

# Add the maxminddb extension to php.ini
RUN echo "extension=maxminddb.so" >> /usr/local/etc/php/php.ini

COPY index.php index.php

ENTRYPOINT exec /root/entrypoint.sh
