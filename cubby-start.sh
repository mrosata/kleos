#!/bin/bash

echo "Cubby - your configuration bootstrapper is \
about to setup this machine for the first time."

# Errors
ERRNO_NOSUDO=101

# Variables
export LOCAL_CUBBY="$HOME/.cubby"
export LOCAL_CONF_DIR="$LOCAL_CUBBY/home-configs"
export CUBBY_CONF_DIR="$PWD/home-configs"

SETUP_GITHUB_CREDS=${SETUP_GITHUB_CREDS:-1}


# Configure Git Credentials easily using ./install-git.sh
if [ $SETUP_GITHUB_CREDS -ne 0 ] && source ./install-git.sh

echo "Creating cubby configs directory"
[ ! -d "$LOCAL_CUBBY" ] && mkdir -p "$LOCAL_CUBBY"
cp "$CUBBY_CONF_DIR/home-configs"/.* "$LOCAL_CONF_DIR"

[ x`which vim` == x ] && install_vim
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  if ./install_vundle.sh then
    echo "[*] - Installed Vundle"
  else
    echo "[x] - Non-zero exit trying to install Vundle"
fi

if [ ! -f "${HOME}/.vimrc" ];then
  # TODO: Setup the vimrc download
  [ -f "$HOME/.vimrc" ] && mv "$HOME/.vimrc" "$HOME/.vimrc~bak$(date +s)"
  [ -f "$LOCAL_CONF_DIR/.vimrc" ] && \
    cat "$LOCAL_CONF_DIR/.vimrc" > "${HOME}/.vimrc"
fi


echo "[*] - About to install docker-ce for debian"
if ./docker-install.sh
then
  echo "Docker Install Script Exited OK"
else
  echo "Docker Install Script Exited with non-zero"
fi


exit 0
