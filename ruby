#!/bin/bash

COMMAND="$(basename "$0")"

CTR_HOST_NAME="$COMMAND-$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 8)"

if [[ -z ${CTR_NAME+x} ]]; then
  CTR_NAME=$CTR_HOST_NAME
fi

ARGS=('--rm' '-it')
#ARGS+=('--user' "$USER:$USER")
#ARGS+=('--user' "$(id -u):$(id -g)")
#ARGS+=('--userns=keep-id')
ARGS+=('--userns=host')
ARGS+=('--hostname' "$CTR_HOST_NAME")
ARGS+=('--name' "$CTR_NAME")

# lots of args to build containers
ARGS+=( '--ipc' 'host' '--network' 'host' '--no-hosts' '--pid' 'host')
ARGS+=('--privileged' '--security-opt' 'label=disable')
ARGS+=('--device' '/dev/fuse')

# mounts
ARGS+=(-v "$HOME/.gem:$HOME/.gem")
ARGS+=(-v "$PWD:$PWD" "--workdir=$PWD")
ARGS+=(-v "$HOME/.bundle:$HOME/.bundle")
ARGS+=(-v "$HOME/.local/bin:$HOME/.local/bin")
ARGS+=(-v "$HOME/.config:$HOME/.config")
ARGS+=(-v "$HOME/src/misc/ctr-bin:$HOME/bin")
ARGS+=(-v "$HOME/.vim:$HOME/.vim")
ARGS+=(-v "$HOME/rpmbuild:$HOME/rpmbuild")
ARGS+=(-v "/var/tmp:/var/tmp")
ARGS+=('--device=/dev/urandom' '--device=/dev/urandom')

# bc we're running as root
ARGS+=(-v "$HOME/.local/share/containers/storage:/var/lib/containers/storage")
ARGS+=(-v "$HOME/.local/share/containers/cache:/var/lib/containers/cache")

# environment variables
ARGS+=(-e "HOME=$HOME" -e "GEM_HOME=$HOME/.gem/ruby" )
ARGS+=(-e GEM_PATH="$HOME/.gem/ruby:$HOME/.gem/ruby/2.5.0:/usr/local/lib/ruby/gems/2.5.0")
ARGS+=(-e "THOR_MERGE=vimdiff" -e "TERM=xterm-256color")
ARGS+=(-e "BUNDLE_GEMFILE=Gemfile")
ARGS+=(-e 'BUILDAH_ISOLATION=chroot')

CTR_PATH="/usr/local/bundle/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin"
CTR_PATH="$CTR_PATH:$HOME/bin:/usr/local/rvm/rubies/ruby-2.5.8/bin:$HOME/.gem/ruby/bin"
ARGS+=(-e "PATH=$CTR_PATH")

## these don't work right in ood with defaults
if [[ -n "$VENDOR_BUNDLE" ]]; then
  ARGS+=(-e "VENDOR_BUNDLE=$VENDOR_BUNDLE") 
fi

if [[ -n "$BUNDLE_PATH" ]]; then
  ARGS+=(-e "BUNDLE_PATH=$BUNDLE_PATH")
fi

# hack for solargraph
if [ -n "$RUBY_PORT" ]; then
  ARGS+=(-p "$RUBY_PORT:$RUBY_PORT")
fi

if [[ -n "$RUBY_DEBUG" ]] && [[ $RUBY_DEBUG ]]; then
  ARGS+=('--log-level=debug')
fi

IMG="ood-build:fedora"

podman run "${ARGS[@]}" "$IMG" "$COMMAND" "$@"
