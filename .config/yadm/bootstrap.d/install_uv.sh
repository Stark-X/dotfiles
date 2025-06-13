#!/bin/bash

# install uv. (ref: https://github.com/astral-sh/uv?tab=readme-ov-file#installation
install () {
  curl -LsSf https://astral.sh/uv/install.sh | sh
  mkdir -p ~/.config/uv/versions/

  # init virtualenv for neovim: 
  uv venv ~/.config/uv/versions/neovim --python 3.12
  # install python package "neovim" and "pynvim" for neovim 
  uv pip install pynvim neovim pip --python ~/.config/uv/versions/neovim/bin/python
}

command -v uv > /dev/null || install
