#!/bin/bash

cd $HOME/codes/rspider/web/
cat ./tmp/pids/unicorn.pid | xargs kill -QUIT
sudo /etc/init.d/nginx stop
