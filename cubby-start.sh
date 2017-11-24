#!/bin/bash

echo "Cubby - your configuration bootstrapper is \
about to setup this machine for the first time."

# Errors
ERRNO_NOSUDO=101

# Variables
LOCAL_CUBBY="${HOME}/.cubby"

function install_vundle {
  git clone https://github.com/VundleVim/Vundle.vim.git \
    "${HOME}/.vim/bundle/Vundle.vim"
}

function install_vim {
  sudo apt-get install vim -y
  [ ! -f "${HOME}/.vimrc" ] && echo "" >> "${HOME}/.vimrc"
}


echo "Creating cubby configs directory"
[ -d "$LOCAL_CUBBY" ] && mkdir "$LOCAL_CUBBY"
cp -a ./home-configs/.* "$LOCAL_CUBBY"

[ x`which vim` == x ] && install_vim
[ x`which git` != x ] && install_vundle

if [ ! -f "${HOME}/.vimrc" ];then
  # TODO: Setup the vimrc download
  [ -f /.vimrc ] && \
    cat "$LOCAL_CUBBY/.vimrc" >> "${HOME}/.vimrc"
fi

echo "About to install vim plugins"
vim +PluginInstall +qall


exit 0
