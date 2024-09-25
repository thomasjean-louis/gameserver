#!/bin/sh

cd /var/www/localhost/htdocs


sed -i "s/'content_server'/'${CONTENT_SERVER}'/g" index.html
sed -i "s/'game_server/'${GAME_SERVER}/g" index.html

sed -i "s/':80'/':${HTTP_PORT}'/g" index.html


echo starting apache server
/usr/sbin/httpd 

cd /quakejs


echo starting nodejs server

node build/ioq3ded.js +set fs_game baseq3 set dedicated 1 +exec server.cfg +set fs_cdn ${CONTENT_SERVER}


echo starting nodejs server started
