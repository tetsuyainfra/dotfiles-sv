#!/bin/bash

DOT_DIR=$(cd $(dirname $0);pwd)

function link_file() {
ln --no-dereference -s "${DOT_DIR}/$1" "$2"
}

function link_file_force() {
ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

function link_dir_force() {
ln --force --no-dereference -s "${DOT_DIR}/$1" "$2"
}

function ConfirmGitInfo(){
  GIT_USERNAME=${GIT_USERNAME:=$(git config --get user.name)}
  if [ -z "${GIT_USERNAME}" ] ; then
    read -p "GIT_USERNAME:" GIT_USERNAME
  fi
  GIT_EMAIL=${GIT_EMAIL:=$(git config --get user.email)}
  if [ -z "${GIT_EMAIL}" ] ; then
    read -p "GIT_EMAIL:" GIT_EMAIL
  fi
}

function ConfirmExecution() {
echo "GIT_USERNAME: $GIT_USERNAME"
echo "GIT_EMAIL   : $GIT_EMAIL"

read -p "ok? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
}


ConfirmGitInfo
set -e
ConfirmExecution

set -x

# creat $HOME/config
mkdir -p $HOME/.config

# Bash
link_file_force "bash/bash_aliases" "${HOME}/.bash_aliases"

# install Git
link_dir_force "git" "${HOME}/.config/git"
if [ -n "${GIT_USERNAME}" -a  -n "${GIT_EMAIL}" ]; then
  git config -f ~/.config/git/config.local --add user.name ${GIT_USERNAME}
  git config -f ~/.config/git/config.local --add user.email ${GIT_EMAIL}
fi

