#!/bin/bash

echo "This script must be ran as root. The reason for this is that"
echo "installing sudo isn't a decision that you can make unless you"
echo "are the root user of a system. This script installs sudo, but"
echo "most systems include sudo already. This is a hack really, I am"
echo "comfortable running this on my system, but you need to make up"
echo "your own mind. Script also adds a user to the /etc/sudoers "
echo "file. "
echo "  -- Pass a user name to add to file as only param to script"

ERRNO_USER=103
ERRNO_ROOT=104

if [ "x`id -au`" != "x0" ];then
  echo "MUST RUN THIS SCRIPT AS ROOT!"
  exit $ERRNO_ROOT
fi

username="$1"

function prompt_user_to_continue {
  local question="${1:-Yes (y) or no (n)}"
  while true
  do
    read -p "$question" answer
    case $answer in
      [yY]* )
        break ;;
      [nN]* ) 
        exit ;;
      * )
        echo "Enter either yes (y) or No (n)" ;;
    esac
  done
}


if [ x"$username" == x ];then
  echo "Pass a username as argument to script, IE:"
  echo "  $0 michael"
  exit 1
fi


if id -au "$username" 2>&1 > /dev/null ; then
   
  if [ x`which sudo` == x ];then
    # Only continue if user says (yes)
    prompt_user_to_continue "Install sudo package?"
    apt-get install sudo -y
  fi
  
  if [ -f /etc/sudoers ]; then
    RES=`cat /etc/sudoers | grep "$username ALL=" | wc -l`
    if [ $RES -gt 0 ];then
      echo "User is already in sudoers file..."
      echo "Use vigr or edit /etc/sudoers manually"
      exit 0
    fi
    # Only add username to sudoers file if user says (yes)
    prompt_user_to_continue "Add $username to /etc/sudoers?"
    echo "$username ALL=(ALL) ALL" >> /etc/sudoers
  fi

else
  echo "Sorry, User named \"$username\" not exists"
  exit $ERRNO_USER
fi

exit 0
