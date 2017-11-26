#!/bin/bash
######################################################################
#### @package   Kleos Bootstraping Script
#### @date      2017-11-26
#### @license   MIT
#### @desc
####   - Kleos sets up your Linux environment (Debian-based), by first
####     * optionally configuring Git global config user.{name|email}
####     * installing packages listed in ./apt-packages.list
####     * update dot files in /home/<user>/.kleos with ./dot-files/*
####     * copy dot files from /home/<user>/.kleos to /home/<user> 
####     * installing Vundle (and vim)
####     * install docker-ce
####

#### Variables
KLEOS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_KLEOS="$HOME/.kleos"
LOCAL_CONF_DIR="$LOCAL_KLEOS/dot-files"
KLEOS_CONF_DIR="$KLEOS_ROOT/dot-files"
INSTALL_SCRIPTS="$KLEOS_ROOT/install-scripts"

#### Should script configure github creds
SETUP_GITHUB_CREDS=${SETUP_GITHUB_CREDS:-1}

#### Error Numbers
source "$KLEOS_ROOT/errno-vars.conf"

echo "Kleos - your configuration bootstrapper is \
about to setup this machine for the first time."


#### Install system packages listed in ./apt-packages.list
####   - if the user has an apt-packages.list file in their home
####     directory then use that file instead of repo version.
sudo apt-get update -y && sudo apt-get upgrade -y
if [ -f "$LOCAL_KLEOS/apt-packages.list" ]; then
  apt_packages_list="$LOCAL_KLEOS/apt-packages.list"
else
  apt_packages_list="$KLEOS_ROOT/apt-packages.list"
fi

[ -f "$apt_packages_list" ] && \
  cat "$apt_packages_list" | xargs sudo apt-get install -y


#### Configure Git Credentials if desired
[ $SETUP_GITHUB_CREDS -ne 0 ] && "$INSTALL_SCRIPTS/install-git.sh"


#### Copy all kleos config files 
echo "Creating kleos configs directory"
mkdir -p "$LOCAL_CONF_DIR"
cp -r "$KLEOS_CONF_DIR/." "$LOCAL_CONF_DIR"


#### Setup Vundle and Vim if not already present
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]; then
  if "$INSTALL_SCRIPTS/install-vundle.sh" ; then
    echo "[*] - Installed Vundle"
  else
    echo "[x] - Non-zero exit trying to install Vundle"
  fi
fi


#### Copy .vimrc config from local config folder to home
if [ ! -f "$HOME/.vimrc" ] ; then
  [ -f "$HOME/.vimrc" ] && \
    cp -b "$HOME/.vimrc" "$HOME/"
  [ -f "$LOCAL_CONF_DIR/.vimrc" ] && \
    cp -u "$LOCAL_CONF_DIR/.vimrc" "$HOME/"
fi


echo "[*] - About to install docker-ce for debian"

if "$INSTALL_SCRIPTS/install-docker.sh" ; then
  echo "Docker Install Script Exited OK"
else
  echo "Docker Install Script Exited with non-zero"
fi


exit 0

