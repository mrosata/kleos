#!/bin/bash
######################################################################
#### Install Docker
####   - Sometimes docker installs easily, and other times it can
####     require special setup. This script attempts to properly 
####     install docker-ce in debian-like environments. It adds a key
####     to the key-ring and checks the fingerprint for accuracy before
####     doing the install. It should work fine, if you've issues, see
####     https://docs.docker.com/engine/installation/linux/docker-ce
####     

sh_c='sh -c'

ARMHF=${ARMHF:-0}
DOCKER_VERSION="${INSTALL_DOCKER_VERSION:-}"
ERRNO_BADKEY=${ERRNO_BADKEY:-102}

function install_docker {
  OSR_ID=$(. /etc/os-release; echo "$ID")
  OS_NAME="$(lsb_release -cs)"
  # Uninstall old versions of docker
  sudo apt-get remove docker docker-engine docker.io -y

  # A few requirements we need regardless:
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl -y
  
  # Depending on if using Wheezy, some deps vary:
  if [ $OS_NAME == "wheezy" ];then
    sudo apt-get install python-software-properties -y
    backports="deb http://ftp.debian.org/debian wheezy-backports main"
    # Found this trick in get.docker.com script
    if ! grep -Fxq "$backports" /etc/apt/sources.list ; then
      (set -x ; $sh_c "echo \"$backports\" >> /etc/apt/sources.list")
    fi
  else
    sudo apt-get install gnupg2 software-properties-common -y
  fi

  curl -fsSL https://download.docker.com/linux/$OSR_ID/gpg | \
    sudo apt-key add -
  # Note: apt-key isn't supposed to be parsed by scripts
  #       because the output isn't gaurenteed. I'm going to
  #       say it's fine here since the string we're grepping
  #       just needs to be part of the fingerprint output.
  VERIFY_KEY=`sudo apt-key fingerprint 0EBFCD88 2>/dev/null | \
    tr -d [:space:] | grep \
    "9DC858229FC7DD38854AE2D88D81803C0EBFCD88" | wc -l`
  
  if [ $VERIFY_KEY -gt 0 ];then
    echo "[*] - Docker key OK"
    if [ $ARMHF -eq 1 ];then
      # Installing on a microcontroller
      echo \
        "deb [arch=armhf] https://download.docker.com/linux/$OSR_ID $OS_NAME stable" | \
        sudo tee /etc/sources.list.d/docker.list
    
    else
      sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/$OSR_ID $OS_NAME stable main" 

    fi #/end update sources.list

    # If using weezy, need to prune one source from source.list
    # because it is non-existant
    if [ "$OS_NAME" == "wheezy" ];then
      sudo cp /etc/apt/sources.list "/etc/apt/sources.list~bak$(date +%s)"
      sudo cat /etc/apt/sources.list | perl -pe \
        's/^deb-src.+docker\.com\/l.+x/d.+n w.+zy s.+e/#$1/g' \
        > /etc/apt/sources.list.tmp
      sudo mv /etc/apt/sources.list.tmp /etc/apt/sources.list
    fi #/end wheezy deb-src comment
    
    sudo apt-get update -y
    if [ -z "$DOCKER_VERSION" ]; then
      sudo apt-get install docker-ce -y
    else
      sudo apt-get install "docker-ce=$DOCKER_VERSION" -y
    fi

    if command -v "docker" > /dev/null 2>&1 ; then
      sudo groupadd docker
      sudo usermod -aG docker "$USER"
    fi
  else
    echo "[x] - Docker key not OK"
    exit $ERRNO_BADKEY
  fi #/end verify key

  if [ x`which docker` != x ]; then
    echo "[*] - Docker seems to have installed successfully"
  fi
}

[ x`which docker` == x ] && install_docker

exit 0