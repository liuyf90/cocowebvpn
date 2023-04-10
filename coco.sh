#!/bin/bash

OPENRESTY_PATH=$(whereis openresty | awk '{print $2}')
echo $OPENRESTY_PATH
#set variable for app_name
APP_NAME="cocowebvpn"
#set variables for nginx_conf
NGINX_CONF=/home/$APP_NAME/nginx.conf


#set variable for nginx_pid
NGINX_PID=/home/$APP_NAME/nginx/logs/nginx.pid


#start nginx service and check if $NGINX_PID not exists
if [ ! -f $NGINX_PID ]; then
    $OPENRESTY_PATH -c $NGINX_CONF
else
    echo "nginx is already running"
fi
