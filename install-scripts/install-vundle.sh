#!/bin/bash
######################################################################
#### Install Vundle
####   @desc This script will install Vundle and Vim if needed.
####   @date 2017-11-25
####   @param1 {number} - 0 install to current user only
####                    - 1 install to current user and skel
####                    - 2 install to current user and root
####                    - 3 install all (essentially 0, 1 and 2)
####


#### Configuration Variables
KLEOS_CONF_DIR="${KLEOS_CONF_DIR:-$HOME/.kleos}"
VUNDLE_PATH=".vim/bundle/Vundle.vim"


#### The SETLVL is either 0,1,2 and dictates where to install
SETLVL=$[$1]
if [ $SETLVL -ne 1 ] && \
   [ $SETLVL -ne 2 ] && \
   [ $SETLVL -ne 3 ]; then
  SETLVL=0
fi


#### Create an array for paths where we'll install vundle
declare -a home_paths
home_paths[0]="$HOME"


#### Install_x flags for script readability
INSTALL_ROOT=$([ $SETLVL -ge 2 ] && echo 1)
INSTALL_SKEL=$([ $SETLVL -eq 1 -o $SETLVL -eq 3 ] && echo 1)
[ "1" == "$INSTALL_ROOT" ] && \
  home_paths[${#home_paths[@]}]="/root"

[ "1" == "$INSTALL_SKEL" ] && \
  home_paths[${#home_paths[@]}]="/etc/skel"

#### Check if a directory is the users home directory
function is_user_home {
  local test_dir="$1"
  if [ "$(dirname "$test_dir")" == "$(dirname "$HOME")" ]; then
    echo 1
  else
    echo 0
  fi
}


#### Copy a configuration file from kleos repo to a home dir
function kleos_config_cp {
  local conf_name="$1"
  local dest_dir="$2"
  conf_path="$KLEOS_CONF_DIR/$conf_name"
  if [ -f "$conf_path" -a -d "$dest_dir" ];then
  
    if [ "$(is_user_home "$dest_dir")" == "1" ]; then
      cp "$conf_path" "$dest_dir"
    else
      sudo cp "$conf_path" "$dest_dir"
    fi
  
  else

    echo "[x] - Kleos unable to copy config file:"
    echo "  source: $conf_path"
    [ ! -f "$conf_path" ] && echo "    (source is not a file)"
    echo "  dest: $dest_dir"
    [ ! -d "$dest_dir" ] && echo "    (dest is not a directory)"
  fi
}


#### Install Vundle
#### param1 {path} - Root Directory of Vundle Install
function install_vundle {
  local root_dir="$1"
  local is_home=$(is_user_home "$1")
  
  # Use sudo to clone the Vundle repo when not in home dir
  if [ "$is_home" != "1" ]; then
    sudo -H mkdir -p "$root_dir/.vim/bundle"
    sudo -H git clone https://github.com/VundleVim/Vundle.vim.git \
      "$root_dir/.vim/bundle/Vundle.vim"
  else # Clone repo without using sudo
    git clone https://github.com/VundleVim/Vundle.vim.git \
      "$root_dir/.vim/bundle/Vundle.vim"
  fi
  
  # Copy vimrc with Vundle config to home (root) folder
  if [ ! -f "$root_dir/.vimrc" ];then
    kleos_config_cp ".vimrc" "$root_dir"
  fi

  # Install the plugins listed in .vimrc
  echo "[*] - About to install vim plugins"
  sleep 0.25 && echo "[*] - Finished.."
  unset root_dir
}


#### Install VIM
function install_vim {
  declare -n root_dir=$1
  sudo apt-get install vim -y -qq >/dev/null
  unset root_dir
}


######################################################################
#### Install Vundle and VIM (if needed)
#### 
#### 1. If vim isn't installed, do so now.
#### 2. For each install directory, check for then setup Vundle

[ x`which vim` == x ] && install_vim

for home_path in "${home_paths[@]}"; do
  if [ ! -d "$home_path/$VUNDLE_PATH" ]; then
    echo "[ ] - About to install Vundle in $home_path"
    (install_vundle "$home_path")
  else
    echo "[*] - Vundle is already installed in $home_path"
  fi
done

#### install plugins through vim, as user, then as root if needed
vim +PluginInstall +qall

unset home_paths

exit 0
