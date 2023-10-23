#!/bin/bash
set -e

cd /workspaces/VestaCore

echo "Building ModSecurity..."
cd ModSecurity
git submodule init
git submodule update
./build.sh
./configure
make
make install
cd ..

echo "Building Nginx with ModSecurity-NGINX connector..."
cd vesta-nginx
./configure --with-compat --add-dynamic-module=../ModSecurity-nginx
make
make install
cd ..

echo "Copying ModSecurity module to Nginx modules directory..."
cp vesta-nginx/objs/ngx_http_modsecurity_module.so vesta-nginx/modules/

echo "Starting Nginx..."
vesta-nginx/sbin/nginx -c vesta-nginx/conf/nginx.conf

echo "Build complete. Nginx with ModSecurity is running."
