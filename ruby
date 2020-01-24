#!/bin/bash

ARGS=(-v "$PWD:/work" "--workdir=/work" "--rm")
ARGS+=('--security-opt' 'label=disable'' --userns=keep-id')

ARGS+=(-v "$HOME/.gem:$HOME/.gem")

ARGS+=(-v "$HOME/.bundle:$HOME/.bundle")
ARGS+=(-v "$HOME/.local/share:$HOME/.local/share")
ARGS+=(-v "$HOME/.local/bin:$HOME/.local/bin")
ARGS+=(-v "$HOME/src/misc/ctr-bin:$HOME/bin")
ARGS+=(-v "/usr/bin/fuse-overlayfs:/usr/bin/fuse-overlayfs")
ARGS+=(-v "$HOME/.vim:$HOME/.vim")

# add all the insane paths for SCLs
RUBY="rh-ruby25"
NODE="rh-nodejs10"
CTR_PATH="/opt/rh/$NODE/root/usr/bin:/opt/rh/$RUBY/root/usr/local/bin:$HOME/bin"
CTR_PATH="$CTR_PATH:/opt/rh/$RUBY/root/usr/bin:/usr/local/sbin"
CTR_PATH="$CTR_PATH:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
CTR_PATH="$CTR_PATH:$HOME/.local/bin"

LD_PATH="/opt/rh/$NODE/root/usr/lib64:/opt/rh/$RUBY/root/usr/local/lib64:/opt/rh/$RUBY/root/usr/lib64"
LD_PATH="$LD_PATH:/usr/lib64"

ARGS+=(-e "PATH=$CTR_PATH" -e "LD_LIBRARY_PATH=$LD_PATH")
ARGS+=(-e "HOME=$HOME" -e "GEM_HOME=$HOME/.gem/ruby" )
ARGS+=(-e "THOR_MERGE=vimdiff" -e "TERM=xterm-256color")
ARGS+=(-e "BUNDLE_GEMFILE=Gemfile")
ARGS+=('-it')

# build containers inside this container
ARGS+=('--device' '/dev/fuse')
ARGS+=(-e '_BUILDAH_STARTED_IN_USERNS=""' -e 'BUILDAH_ISOLATION=chroot')

if [ -n "$RUBY_PORT" ]; then
  ARGS+=(-p "$RUBY_PORT:$RUBY_PORT")
fi

if [[ -n "$RUBY_DEBUG" ]] && [[ $RUBY_DEBUG ]]; then
  ARGS+=('--log-level=debug')
fi

IMG="ood:dev"

podman run "${ARGS[@]}" "$IMG" "$(basename "$0")" "$@"
