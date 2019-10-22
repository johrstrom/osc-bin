#!/bin/bash

WRK=$(echo $PWD | sed -e "s#$GOPATH#/go#g")
IMG="go:extra"
#IMG="golang:alpine"

ARGS=(--rm -v "$GOPATH:/go" '--security-opt' 'label=disable')
ARGS+=('--userns=keep-id') 
ARGS+=("-w=$WRK")
ARGS+=(-v "/usr/include:/usr/include")

if [ -n "$GO111MODULE" ]; then
  ARGS+=(-e "GO111MODULE=$GO111MODULE" )
fi

podman run "${ARGS[@]}" "$IMG" go "$@"
#podman run "${ARGS[@]}" golang:buster "$@"
