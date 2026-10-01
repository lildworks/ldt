FROM eclipse-temurin:21-jre-alpine

RUN apk update && apk upgrade --no-cache

COPY ./dist/libs/application.jar /srv/application.jar

VOLUME [ "/srv/application.properties" ]

WORKDIR /srv

SHELL [ "/bin/sh", "-c" ]

ENTRYPOINT exec java \
    -XshowSettings:vm \
    -XX:+UnlockExperimentalVMOptions \
    -XX:+UseContainerSupport \
    -Dfile.encoding=UTF-8 \
    -Djava.security.egd=file:/dev/./urandom \
    -jar application.jar

EXPOSE 9080
