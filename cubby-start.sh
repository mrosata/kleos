#!/bin/bash

echo "Cubby - your configuration bootstrapper is \
about to setup this machine for the first time."

# Errors
ERRNO_NOSUDO=101

# Variables
LOCAL_CUBBY="$HOME/.cubby"
LOCAL_CONF_DIR="$LOCAL_CUBBY/home-configs"
CUBBY_CONF_DIR="$PWD/home-configs"

SETUP_GITHUB_CREDS=${SETUP_GITHUB_CREDS:-1}


# Configure Git Credentials easily using ./install-git.sh
[ $SETUP_GITHUB_CREDS -ne 0 ] && ./install-git.sh

echo "Creating cubby configs directory"
[ ! -d "$LOCAL_CUBBY" -o ! -d "$LOCAL_CONF_DIR" ] && \
  mkdir -p "$LOCAL_CONF_DIR"
cp "${CUBBY_CONF_DIR}"/.* "$LOCAL_CONF_DIR"

if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  if ./install-vundle.sh ; then
    echo "[*] - Installed Vundle"
  else
    echo "[x] - Non-zero exit trying to install Vundle"
  fi
fi

# TODO: Setup the vimrc download
if [ ! -f "${HOME}/.vimrc" ];then
  [ -f "$HOME/.vimrc" ] && \
    mv "$HOME/.vimrc" "$HOME/.vimrc~bak"
  [ -f "$LOCAL_CONF_DIR/.vimrc" ] && \
    cat "$LOCAL_CONF_DIR/.vimrc" > "${HOME}/.vimrc"
fi


echo "[*] - About to install docker-ce for debian"
if ./install-docker.sh ; then
  echo "Docker Install Script Exited OK"
else
  echo "Docker Install Script Exited with non-zero"
fi


exit 0;
