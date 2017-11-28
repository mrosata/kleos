######################################################################
#### @application  bash
#### @type  config-file
#### @desc
####   ~/.bashrc: executed by bash(1) for non-login shells.
#### @see
####   /usr/share/doc/bash/examples/startup-files
####

#### If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

#### check the window size after each command and, if necessary,
#### update the values of LINES and COLUMNS.
shopt -s checkwinsize

#### pathname expansion match "**" to > 0 (sub)directories.
shopt -s globstar

#### append to the history file, don't overwrite it
shopt -s histappend

#### ignore duplicate lines and lines starting with space in history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

#### less can work with non-text files better
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#### set variable identifying the chroot you work in
####   - (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

#### set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

#### I always want to try to have prompt colors
if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    color_prompt=yes
  else
    # Wahhhhw-woohhh~whaaaa
    color_prompt=
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

#### If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
        PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
        ;;
    *)
        ;;
esac

#### enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || \
        eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

#### colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -l'  # long
alias lt='ls -lt' # time
alias la='ls -A'  # all (minus ./ and ../)
alias l='ls -CF'  # columns and classify, ie: suffix with (/*=>@|)

#### Additional aliases if available
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

#### enable programmable completion features (don't need to enable this
#### if it's already enabled in /etc/bash.bashrc and /etc/profile
#### sources /etc/bash.bashrc)
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#### Try to improve upon CDPATH variable (add paths to docs)
#### Array of paths to add to CDPATH if they exist
declare -a potential_cd_paths=(
    /usr/share/doc
    /usr/share/doc-base
    /usr/share/xubuntu-docs
    /usr/share/debian-docs
)

#### Test each path, if they exists and are not in CDPATH
#### then add that path to the CDPATH environment var
for test_path in "${potential_cd_paths[@]}"; do
  in_path=`echo $CDPATH | grep "$test_path" | wc -l`
  if [ -d "$test_path" -a $in_path -eq 0 ]; then
    # Add test_path to CDPATH
    CDPATH="$CDPATH:$test_path"
  fi
  unset in_path
done

#### Make sure CDPATH doesn't start with a ":"
export CDPATH=`echo "$CDPATH" | perl -pe 's/^:(.*)/$1/'`


#### always change to home directory when first logging in
if [ -d "$HOME" ]; then
  cd "$HOME"
fi
