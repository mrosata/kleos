#### Kleos (A Linux Bootstrapper)
Quickly setup new linux environments by setting up and installing packages based on past personal configurations. Created to work in Debian(*-like*) linux environments.

The `apt-packages.list` file should be a list of packages that can be installed with nothing other than `apt` or in the case of the script `apt-get`. These packages aren't needed to run Kleos bootstrapper, so feel free to update or remove packages from this list.

##### Changelog
- __2017-11-24__ - Started Kleos project. Is able to setup Vundle and Docker-CE
- __2017-11-25__ - Improved the Vundle install script, improved Git global config so it doesn't create multiple global variables. Kleos now installs the list of packages in the `apt-packages.list` file prior to anything else. Install scripts for `vundle` and `docker-ce` no longer are sourced, rather they are ran in a subshell and Kleos Bootstrapper reports their success or failure. Added `setup-sudo.sh` script for root user to setup sudo and add user into `/etc/sudoers` automagically *(use with care)*
