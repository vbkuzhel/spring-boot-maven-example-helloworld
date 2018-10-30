#!/bin/bash
filebeat -e -c /filebeat/filebeat.yml &
java -Xmx200m -jar spring.war -Dprofile=$profile
