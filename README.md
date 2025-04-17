# GeoIP

Old version running php 7.4

Simple PHP based GeoIP server that based off: https://github.com/fiorix/freegeoip

This has a built-in cron to update the database once per day. And it uses the PHP GeoIP C extension to improve response time.

Container uses port 80 by default and can output the result in either JSON or XML 

localhost:80/json/8.8.8.8
```
{
  "ip": "8.8.8.8",
  "country_code": "US",
  "country_name": "United States",
  "time_zone": "America/Chicago",
  "region_code": null,
  "region_name": null,
  "city": null,
  "zip_code": null,
  "latitude": 37.751,
  "longitude": -97.822
}
```

localhost:80/xml/8.8.8.8
```
<?xml version="1.0"?>
<Responese>
  <IP>8.8.8.8</IP>
  <CountryCode>US</CountryCode>
  <CountryName>United States</CountryName>
  <TimeZone>America/Chicago</TimeZone>
  <RegionCode></RegionCode>
  <RegionName></RegionName>
  <City></City>
  <ZipCode></ZipCode>
  <Latitude>37.751</Latitude>
  <Longitude>-97.822</Longitude>
</Responese>
```

A prebuilt docker image is available at: [learningstaircase/geoip](https://hub.docker.com/r/learningstaircase/geoip)
You need to sign up for a free account on Maxmind to use, and include these enviromental variables:
```
USER_ID={{USER_ID_HERE}} 
LICENSE_KEY={{LICENCE_KEY_HERE}}
PORT=80
```
