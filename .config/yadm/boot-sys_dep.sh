#!/bin/bash

linux_init() {
  if ! locale-check en_US.UTF-8; then
    sudo locale-gen en_US.UTF-8
  fi

  sudo apt install unzip zip traceroute dnsutils silversearcher-ag bison gcc lua5.4 make telnet batcat

  ln -s /usr/bin/batcat $HOME/.local/bin/bat
}

system_type=$(uname -s)

if [[  "$system_type" = "Linux" || "$system_type" = "WSL" ]]; then
  linux_init
fi

# vim: set ft=bash
