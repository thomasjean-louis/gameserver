FROM node:18-alpine as build

RUN apk --no-cache --no-check-certificate update upgrade 
RUN apk --no-check-certificate add jq apache2 curl

RUN mkdir -p /run/apache2

COPY ./setup_12.x setup_12.x

COPY ./quakejs /quakejs

WORKDIR /quakejs
RUN npm install

COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg

COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN rm /var/www/localhost/htdocs/index.html && cp /quakejs/html/* /var/www/localhost/htdocs/
COPY ./include/assets/ /var/www/localhost/htdocs/assets


WORKDIR /
ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
