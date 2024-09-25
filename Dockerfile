FROM node:18-alpine as build

RUN apk --no-cache --no-check-certificate update
RUN apk --no-cache --no-check-certificate upgrade
RUN apk --no-cache --no-check-certificate add jq
RUN apk --no-cache --no-check-certificate add apache2
RUN apk --no-cache --no-check-certificate add curl

RUN mkdir -p /run/apache2
# RUN exec /usr/sbin/httpd -D FOREGROUND
# CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]


COPY ./setup_12.x setup_12.x

COPY ./quakejs /quakejs


WORKDIR /quakejs
RUN npm install
RUN ls
COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg

COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN ls /var/www/localhost/htdocs
RUN rm /var/www/localhost/htdocs/index.html && cp /quakejs/html/* /var/www/localhost/htdocs/
COPY ./include/assets/ /var/www/localhost/htdocs/assets


WORKDIR /
ADD entrypoint.sh /entrypoint.sh
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
