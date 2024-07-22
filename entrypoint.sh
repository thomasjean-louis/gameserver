#!/bin/sh

cd /var/www/html

#sed -i "s/'quakejs:/window.location.hostname + ':/g" index.html

sed -i "s/'content_server'/'${CONTENT_SERVER}'/g" index.html
sed -i "s/'game_server/'${GAME_SERVER}/g" index.html

sed -i "s/':80'/':${HTTP_PORT}'/g" index.html

/etc/init.d/apache2 start

cd /quakejs

# SSL
make-ssl-cert generate-default-snakeoil --force-overwrite
KEY_VALUE=$(cat /etc/ssl/private/ssl-cert-snakeoil.key)
CERT_VALUE=$(cat /etc/ssl/certs/ssl-cert-snakeoil.pem)
echo '{"key":"'"$KEY_VALUE"'","cert":"'"$CERT_VALUE"'"}' >> wssproxy.json

node build/ioq3ded.js +set fs_game baseq3 set dedicated 1 +exec server.cfg +set fs_cdn ${CONTENT_SERVER}

node bin/wssproxy.js --config ./wssproxy.json

