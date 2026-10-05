FROM eclipse-temurin:21-jre-alpine

ARG JAR_FILE=libs/application.jar

RUN apk update && \
    apk upgrade --no-cache

COPY ./dist/${JAR_FILE} /srv/application.jar

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
