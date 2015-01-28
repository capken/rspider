#!/bin/bash

cd $HOME/codes/rspider/web/
unicorn -c deploy/unicorn.rb -D
sudo cp deploy/nginx.conf /etc/nginx/nginx.conf
sudo /etc/init.d/nginx start
