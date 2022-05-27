FROM php:7.4-apache

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

# Install GeoIP PHP extension.
RUN apt-get update \
    && apt-get install -y libmaxminddb-dev wget cron unzip vim \
    && pecl install maxminddb \
    && install-php-extensions geoip zip xmlrpc
RUN curl -L -s $(curl -L -s https://api.github.com/repos/maxmind/geoipupdate/releases/latest | grep -o -E "https://(.*)geoipupdate_(.*)_linux_amd64.deb") --output geoip-update.deb

RUN (crontab -l ; echo "16 3 * * * /usr/bin/geoipupdate -v >> /proc/1/fd/1 2>&1") | crontab

RUN dpkg -i geoip-update.deb

ADD entrypoint.sh /root/entrypoint.sh
RUN chmod o+x /root/entrypoint.sh

RUN curl -sS https://getcomposer.org/installer | php

RUN php composer.phar require maxmind-db/reader:~1.0
RUN a2enmod rewrite expires
ADD .htaccess /var/www/html/.htaccess

COPY index.php index.php

ENTRYPOINT /root/entrypoint.sh