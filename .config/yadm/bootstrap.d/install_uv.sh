#!/bin/bash

# install uv. (ref: https://github.com/astral-sh/uv?tab=readme-ov-file#installation
install () {
  curl -LsSf https://astral.sh/uv/install.sh | sh
  mkdir -p ~/.config/uv/versions/

  # init virtualenv for neovim: 
  $HOME/.local/bin/uv venv ~/.config/uv/versions/neovim --python 3.13
  # install python package "neovim" and "pynvim" for neovim 
  $HOME/.local/bin/uv pip install pynvim neovim pip --python ~/.config/uv/versions/neovim/bin/python
}

command -v uv > /dev/null || install
