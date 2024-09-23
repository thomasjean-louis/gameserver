FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=US/Eastern

RUN apt-get update
RUN apt-get upgrade -y

#RUN apt-get install -y wget 
RUN apt-get install  sudo -y
RUN apt-get install  curl -y
RUN apt-get install  npm -y
RUN apt-get install  jq -y
RUN apt-get install  apache2 -y
RUN apt-get install  apt-utils -y


COPY ./setup_12.x setup_12.x
RUN sudo -E bash -

COPY ./quakejs /quakejs


WORKDIR /quakejs
RUN npm install
RUN ls
COPY server.cfg /quakejs/base/baseq3/server.cfg
COPY server.cfg /quakejs/base/cpma/server.cfg
# The two following lines are not necessary because we copy assets from include.  Leaving them here for continuity.
# WORKDIR /var/www/html
# RUN bash /var/www/html/get_assets.sh
COPY ./include/ioq3ded/ioq3ded.fixed.js /quakejs/build/ioq3ded.js

RUN rm /var/www/html/index.html && cp /quakejs/html/* /var/www/html/
COPY ./include/assets/ /var/www/html/assets
RUN ls /var/www/html

WORKDIR /
ADD entrypoint.sh /entrypoint.sh
# Was having issues with Linux and Windows compatibility with chmod -x, but this seems to work in both
RUN chmod 777 ./entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
