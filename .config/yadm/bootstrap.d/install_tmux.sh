#!/bin/bash

# tpm should be installed by git
install() {
  ln -s -f ~/oh-my-tmux/.tmux.conf ~/.tmux.conf
  # install tpm to manage the tmux plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

command -v tmux > /dev/null || install

