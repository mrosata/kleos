#!/bin/bash

# Errors
ERRNO_NOSUDO=101

# Variables
LOCAL_KLEOS="$HOME/.kleos"
LOCAL_CONF_DIR="$LOCAL_KLEOS/home-configs"
KLEOS_CONF_DIR="$PWD/home-configs"

SETUP_GITHUB_CREDS=${SETUP_GITHUB_CREDS:-1}

echo "Kleos - your configuration bootstrapper is \
about to setup this machine for the first time."


# Install packages list in apt-packages.list file using apt-get
sudo apt-get update -y && sudo apt-get upgrade -y
apt_packages_list="$PWD/apt-packages.list"
[ -f "$apt_packages_list" ] && \
  cat "$apt_packages_list" | xargs sudo apt-get install -y


# Configure Git Credentials easily using "$PWD/install-git.sh"
[ $SETUP_GITHUB_CREDS -ne 0 ] && "$PWD/install-git.sh"


# Copy all kleos config files 
echo "Creating kleos configs directory"
mkdir -p "$LOCAL_CONF_DIR"
cp -r "$KLEOS_CONF_DIR/." "$LOCAL_CONF_DIR"


# Setup Vundle and Vim if not already present
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  if "$PWD/install-vundle.sh" ; then
    echo "[*] - Installed Vundle"
  else
    echo "[x] - Non-zero exit trying to install Vundle"
  fi
fi


# Copy .vimrc config from local config folder to home
if [ ! -f "$HOME/.vimrc" ] ; then
  [ -f "$HOME/.vimrc" ] && \
    cp -b "$HOME/.vimrc" "$HOME/"
  [ -f "$LOCAL_CONF_DIR/.vimrc" ] && \
    cp -u "$LOCAL_CONF_DIR/.vimrc" "$HOME/"
fi


echo "[*] - About to install docker-ce for debian"
if "$PWD/install-docker.sh" ; then
  echo "Docker Install Script Exited OK"
else
  echo "Docker Install Script Exited with non-zero"
fi


exit 0

