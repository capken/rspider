#!/bin/bash

cd /home/allen/codes/rspider/web/
cat ./tmp/pids/unicorn.pid | xargs kill -QUIT
sudo /etc/init.d/nginx stop
