#!/bin/bash

export RSPIDER_HOME=$HOME/codes/rspider/web
unicorn -c $RSPIDER_HOME/deploy/unicorn.rb -D
sudo /usr/sbin/nginx -c $RSPIDER_HOME/deploy/nginx.conf
