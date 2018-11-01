#!/bin/sh
/usr/bin/filebeat -e -c /filebeat/filebeat.yml &
cd /opt/app
/usr/bin/java -Xmx200m -jar spring.war -Dprofile=$profile
