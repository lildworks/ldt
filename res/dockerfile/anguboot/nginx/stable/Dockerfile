FROM nginx:stable

ARG HTML_FOLDER=app/browser

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoremove -y

COPY ./dist/${HTML_FOLDER} /usr/share/nginx/html

WORKDIR /usr/share/nginx/html
