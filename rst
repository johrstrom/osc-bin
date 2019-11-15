#!/bin/sh

redir="/pun/dev/dashboard"

if [ -z "$1" ]; then
  port="8080"
else
  port="$1"
fi

#ood_user="ood:ood"
ood_user="jeff:jeff"
server="localhost:$port"
url_path="/nginx/stop?redir=$redir"

curl -u $ood_user -X POST http://$server$url_path
