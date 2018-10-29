FROM openjdk:8-jdk-alpine
LABEL maintainer="GSD"
LABEL description="activitiengine-integration"

RUN apk add --no-cache tzdata
ENV FILEBEAT_VERSION=5.3.1

COPY filebeat/filebeat.yml /

RUN apk add --update-cache curl && \
    rm -rf /var/cache/apk/* && \
    curl https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -o /filebeat.tar.gz && \
    tar xzvf filebeat.tar.gz && \
    rm filebeat.tar.gz && \
    mv filebeat-${FILEBEAT_VERSION}-linux-x86_64 filebeat && \
    cd filebeat && \
    cp filebeat /usr/bin && \
    rm -rf /filebeat/filebeat.yml && \
    cp /filebeat.yml /filebeat/ && \
    ls -ltr /filebeat && \
    cat /filebeat/filebeat.yml
ENV TZ Europe/Berlin

RUN ["mkdir", "-p", "/opt/app"]
WORKDIR /opt/app

COPY ["target/*.war", "spring.war"]
COPY filebeat/filebeat.yml /etc/filebeat/filebeat.yml
#COPY ["/opt/certificates/keystore.jks", "configuration/keystore.jks"]

EXPOSE 8080

CMD [ "filebeat", "-e" , "-c", "/filebeat/filebeat.yml"]
ENTRYPOINT ["java", "-Xmx200m", "-jar", "spring.war", "-Dprofile=$profile"]

