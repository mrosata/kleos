#!/bin/bash
#####################################################################
#### A bit of a catch-22 here. If the system doesn't have
#### git installed, then cubby won't be able to do its
#### thing (since your files are stored in a git repo).
####
#### If you have your files on the machine hosting cubby already,
#### or if you just need to install git then use this script.
#### (If your not me, make sure to change the GIT_USERNAME and 
#### GIT_EMAIL variables)
####


# Github info
GIT_USERNAME="${GIT_USERNAME:-Michael Rosata}"
GIT_EMAIL="${GIT_EMAIL:-mrosata1984@gmail.com}"

ERRNO_NOSUDO=101

function install_git {
  echo "Installing git..."
  if [ x`which sudo` == x ];then
    echo "Unfortunetly you do not have sudo installed"
    echo "log in as root and run:"
    echo "  apt-get install sudo -y"
    echo "and then add:"
    echo "  ${WHOAMI} ALL=(ALL) ALL "
    echo "to the /etc/sudoers file"
    exit $ERRNO_NOSUDO
  fi

  sudo apt-get update -y
  sudo apt-get install git-core -y
}

# Check for git and run install function if not found
[ x`which git` = x ] && install_git


git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"

