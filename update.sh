#!/bin/sh
# Update GeoIP2-City database
URL=$(cat /root/url.conf 2>/dev/null)

if [ -n "${URL}" ]; then
  # Check if the URL is provided
  curl -L -s ${URL} -o GeoIP2-City.tar.gz
  tar -xzf GeoIP2-City.tar.gz -C /usr/share/GeoIP/ --strip-components=1 --wildcards '*/GeoLite2-City.mmdb'
  echo "Updated GeoIP2-City database at $(date) using provided URL"
else
  # If no URL is provided, use geoipupdate
  /usr/bin/geoipupdate
  echo "Updated GeoIP database at $(date) using geoipupdate"
fi