#!/bin/sh

cd /var/www/localhost/htdocs

#sed -i "s/'quakejs:/window.location.hostname + ':/g" index.html

sed -i "s/'content_server'/'${CONTENT_SERVER}'/g" index.html
sed -i "s/'game_server/'${GAME_SERVER}/g" index.html

sed -i "s/':80'/':${HTTP_PORT}'/g" index.html

# /etc/init.d/apache2 start

echo starting apache server
# exec /usr/sbin/httpd -D FOREGROUND
/usr/sbin/httpd 

cd /quakejs


echo starting nodejs server

node build/ioq3ded.js +set fs_game baseq3 set dedicated 1 +exec server.cfg +set fs_cdn ${CONTENT_SERVER}


echo starting nodejs server started
