FROM nginx:stable

ARG DIST=dist/app/browser

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y

COPY ./${DIST} /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
