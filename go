#!/bin/bash

WRK=$PWD
# go:extra has a little bit extra packages like selinux or other .so libs
IMG="go:extra"

# GOHOME used here is $HOME/src/go (for me). Can't use GOPATH bc some ppl
# (*cough* runc *cough*) add to GOPATH which makes it /go/path:/added/thing.
# try to mount $GOPATH:/go and isn't a valid podman mount arg anymore
ARGS=(--rm -v "$GOHOME:$GOHOME" '--security-opt' 'label=disable')
ARGS+=('--userns=keep-id') 
ARGS+=("-w=$PWD")

ARGS+=(-e "GOPATH=$GOPATH")

if [ -n "$GO111MODULE" ]; then
  ARGS+=(-e "GO111MODULE=$GO111MODULE" )
fi

echo $@

podman run "${ARGS[@]}" "$IMG" go "$@"
