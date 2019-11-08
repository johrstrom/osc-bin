#!/bin/bash

ARGS=(-v "$PWD:/work" "--workdir=/work")

podman run ${ARGS[@]} ood:test rake "$@"
