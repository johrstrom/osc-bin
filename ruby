#!/bin/bash

ARGS=(-v "$PWD:/work" "--workdir=/work" "--rm")
ARGS+=('--security-opt' 'label=disable'' --userns=keep-id')
ARGS+=(-v "$HOME/.gem:$HOME/.gem")
ARGS+=(-v "$HOME/.bundle:$HOME/.bundle")
#ARGS+=(-v "$HOME/.gem/ruby:/var/lib/gems/2.5.0")
ARGS+=(-v "$HOME/src/misc/ctr-bin:$HOME/bin")

# add all the insane paths for SCLs
RUBY="rh-ruby25"
NODE="rh-nodejs10"
CTR_PATH="/opt/rh/$NODE/root/usr/bin:/opt/rh/$RUBY/root/usr/local/bin:$HOME/bin"
CTR_PATH="$CTR_PATH:/opt/rh/$RUBY/root/usr/bin:/usr/local/sbin"
CTR_PATH="$CTR_PATH:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
LD_PATH="/opt/rh/$NODE/root/usr/lib64:/opt/rh/$RUBY/root/usr/local/lib64:/opt/rh/$RUBY/root/usr/lib64"

ARGS+=(-e "PATH=$CTR_PATH" -e "LD_LIBRARY_PATH=$LD_PATH") #-e "BUNDLE_BIN=$HOME/bin")
ARGS+=('-it')

podman run ${ARGS[@]} ood:dev $(basename "$0") "$@"
