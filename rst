#!/bin/sh

redir="/pun/dev/dashboard"

ood_user="ood:ood"
server="localhost:8080"
url_path="/nginx/stop?redir=$redir"

curl -u $ood_user -X POST http://$server$url_path
