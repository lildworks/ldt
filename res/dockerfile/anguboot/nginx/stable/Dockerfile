FROM nginx:stable

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y

COPY ./dist/conf/nginx.conf /etc/nginx/nginx.conf

COPY ./dist/app/browser /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
