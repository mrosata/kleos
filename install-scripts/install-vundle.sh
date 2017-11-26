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
KLEOS_CONF_DIR="${KLEOS_CONF_DIR:-${HOME}/.kleos}"
VUNDLE_PATH=".vim/bundle/Vundle.vim"

#### The SETLVL is either 0,1,2 and dictates where to install
SETLVL=$[$1]
if [ $SETLVL -ne 1 ] && \
   [ $SETLVL -ne 2 ] && \
   [ $SETLVL -ne 3 ]; then
  SETLVL=0
fi


# Create an array for paths where we'll install vundle
declare -a home_paths
home_paths[0]="$HOME"

# Install_x flags for script readability
INSTALL_ROOT=$([ $SETLVL -ge 2 ] && echo 1)
INSTALL_SKEL=$([ $SETLVL -eq 1 -o $SETLVL -eq 3 ] && echo 1)
[ 1 -eq $INSTALL_ROOT ] && \
  home_paths[${#home_paths[@]}]="/root"

[ 1 -eq $INSTALL_SKEL ] && \
  home_paths[${#home_paths[@]}]="/etc/skel"


function kleos_config_cp {
  local conf_name="$1"
  local dest_dir="$2"
  conf_path="$KLEOS_CONF_DIR/$conf_name"
  if [ -f "$conf_path" -a -d "$dest_dir" ];then
    cp "conf_path" "$dest_dir"
  else
    echo "[x] - Kleos unable to copy config file:"
    echo "  source: $conf_path"
    [ ! -f "$conf_path" ] && "    (source is not a file)"
    echo "  dest: $dest_dir"
    [ ! -d "$dest_dir" ] && "    (dest is not a directory)"
  fi
}

# Install Vundle
# param1 {path} - Root Directory of Vundle Install
function install_vundle {
  local root_dir="$1"

  git clone https://github.com/VundleVim/Vundle.vim.git \
    "$root_dir/.vim/bundle/Vundle.vim"

  # Copy vimrc with Vundle config to home (root) folder
  if [ ! -f "$root_dir/.vimrc" ];then
    kleos_config_cp ".vimrc" "$root_dir"
  fi

  # Install the plugins listed in .vimrc
  echo "[*] - About to install vim plugins"
  vim +PluginInstall +qall
  unset root_dir
}

function install_vim {
  declare -n root_dir=$1
  sudo apt-get install vim -y
  unset root_dir
}

# 1. If vim isn't installed, do so now.
[ x`which vim` == x ] && install_vim

# 2. For each desired install, check and then setup Vundle
for home_path in "${home_paths[@]}"; do
  if [ ! -d "$home_path/$VUNDLE_PATH" ]; then
    echo "[ ] - About to install Vundle in $home_path"
    install_vundle "$home_path"
  else
    echo "[*] - Vundle is already installed in $home_path"
  fi
done

unset home_paths

exit 0
