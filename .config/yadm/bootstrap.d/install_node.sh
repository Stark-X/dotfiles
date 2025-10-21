#!/bin/bash

install() {
  echo "installing tj/n ..."
  curl -L https://bit.ly/n-install | bash -s -- -y
}

command -v n >/dev/null || install

install_bun() {
  echo "installing bun ..."
  curl -fsSL https://bun.com/install | bash
  $HOME/.bun/bin/bun i -g neovim
}

command -v bun >/dev/null || install_bun
