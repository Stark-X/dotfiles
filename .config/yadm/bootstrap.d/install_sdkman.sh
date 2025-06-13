#!/bin/bash

install() {
  curl -s "https://get.sdkman.io" | bash
}

command -v sdkman > /dev/null || install
