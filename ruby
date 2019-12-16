#!/bin/bash

ARGS=(-v "$PWD:/work" "--workdir=/work" "--rm")
ARGS+=('--security-opt' 'label=disable'' --userns=keep-id')
ARGS+=(-v "$HOME/.gem:$HOME/.gem")
ARGS+=(-v "$HOME/.gem/ruby:/var/lib/gems/2.5.0")
ARGS+=(-v "$HOME/src/misc/ctr-bin:/usr/local/bin")

podman run ${ARGS[@]} ood:test $(basename "$0") "$@"
