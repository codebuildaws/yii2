#!/bin/bash

echo "Starting Xvfb ..."
Xvfb -ac -screen scrn 1280x2000x24 :9.0 &
export DISPLAY=:9.0

# start services in background here
echo "cron..."
cron

# start services in background here
echo "Starting PHP-FPM..."
service php7.1-fpm start

echo "Starting NGINX..."
service nginx start
cd /app/src/node-apps/websocket-proxy; supervisor app.js > /dev/null 2>&1

while true
do
    sleep 1
done
exit 0
