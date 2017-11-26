#### Kleos (A Linux Bootstrapper)
Quickly setup new linux environments by setting up and installing packages based on past personal configurations. Created to work in Debian(*-like*) linux environments.

The `apt-packages.list` file should be a list of packages that can be installed with nothing other than `apt` or in the case of the script `apt-get`. These packages aren't needed to run Kleos bootstrapper, so feel free to update or remove packages from this list.


##### Quick How-To
If you know what your doing, just run the `kleos-start.sh` script. Ensure that
sudo is installed on your local machine before beginning.


##### Custom Configuration
There are a few ways in which you can configure __Kleos__ to behave differently
on different machines. The easiest configuration is adding/removing packages
that Kleos installs using `apt-get` by simply adding/removing package names from
the `apt-packages.list` file in your `$HOME/.kleos/` directory.


##### Detailed How-To
To use this script, simply clone this repo then run main script `kleos-start.sh`:
```sh
$ git clone https://github.com/mrosata/kleos.git
$ ./kleos/kleos-start.sh
```
This will install all the packages in the `apt-packages.list` file in project directory, Vim, Vundle, Vundle Plugins configured in .vimrc (which is copied from `home-configs` directory), docker-ce and it will also setup global github user.name and user.email if you set appropriate environment vars ahead of time.

If you don't already have `sudo` installed on your distro, you can use the helper script:

```sh
# ./setup-sudo.sh <username>
```
where `<username>` is the name of a user that you want to give sudo privilages too. You need to be root, the script will test for this and it will prompt you before any actions are taken as well.

The reason you must have sudo installed is that __Kleos__ uses the `sudo` program to install packages. Perhaps this isn't the best approach, and I'm taking it into consideration that the script could simply be run as root, I mean, why not? In any case, the `setup-sudo.sh` script works fine. For more info on sudo see [Debian Reference](https://www.debian.org/doc/manuals/debian-reference/ch01.en.html#_sudo_configuration)


##### Changelog
- __2017-11-24__ - Started Kleos project. Is able to setup Vundle and Docker-CE
- __2017-11-25__ - Improved the Vundle install script, improved Git global config so it doesn't create multiple global variables. Kleos now installs the list of packages in the `apt-packages.list` file prior to anything else. Install scripts for `vundle` and `docker-ce` no longer are sourced, rather they are ran in a subshell and Kleos Bootstrapper reports their success or failure. Added `setup-sudo.sh` script for root user to setup sudo and add user into `/etc/sudoers` automagically *(use with care)*
- __2017-11-26__ - Organized scripts into folders, can now run kleos from external directory. Fixed deb apt package source list problem caused by docker install.

