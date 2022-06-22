#!/bin/sh
cat << EOF > /etc/GeoIP.conf
UserId $USER_ID
LicenseKey $LICENSE_KEY

ProductIds GeoLite2-City

DatabaseDirectory /usr/share/GeoIP
EOF
if [ -n "${PORT}" ]; then
  sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
fi
/usr/bin/geoipupdate -v >> /proc/1/fd/1 2>&1
cron start && apache2-foreground
