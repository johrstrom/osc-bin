#!/bin/bash

node="rh-nodejs10"
ruby="rh-ruby25"

CTR_PATH="/home/jeff/bin:/opt/rh/$node/root/usr/bin:/opt/rh/$ruby/root/usr/local/bin"
CTR_PATH="$CTR_PATH:/opt/rh/$ruby/root/usr/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
CTR_LD="/opt/rh/$node/root/usr/lib64:/opt/rh/$ruby/root/usr/local/lib64:/opt/rh/$ruby/root/usr/lib64"


MNTS=(-v "$PWD:/work")

ARGS=("${MNTS[@]}")
ARGS+=("--workdir=/work")
ARGS+=(-e "PATH=$CTR_PATH" -e "LD_LIBRARY_PATH=$CTR_LD")

podman run ${ARGS[@]} ood-build rake "$@"
