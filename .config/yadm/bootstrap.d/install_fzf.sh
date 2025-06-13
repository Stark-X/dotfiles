#!/bin/bash

install() {
  ~/.fzf/install
}

command -v fzf > /dev/null || install
