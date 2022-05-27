#!/bin/sh
cat << EOF > /etc/GeoIP.conf
UserId $USER_ID
LicenseKey $LICENSE_KEY

ProductIds GeoLite2-City

DatabaseDirectory /usr/share/GeoIP
EOF
cron start &&
/usr/bin/geoipupdate -v >> /proc/1/fd/1 2>&1
apache2-foreground