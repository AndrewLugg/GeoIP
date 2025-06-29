#!/bin/sh
cat << EOF > /etc/GeoIP.conf
UserId $USER_ID
LicenseKey $LICENSE_KEY

ProductIds GeoLite2-City

DatabaseDirectory /usr/share/GeoIP
EOF

echo "$URL" > /root/url.conf

/root/update.sh

if [ -n "${PORT}" ]; then
  sed -i "s/Listen 80/Listen $PORT/" /etc/apache2/ports.conf
fi
cron start && apache2-foreground
