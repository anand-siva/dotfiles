#!/usr/bin/env bash
set -e

source bin/helpers.sh

OS="$(uname -s)"

if [[ "$OS" == "Darwin" ]]; then
  source install/macos.sh
elif [[ "$OS" == "Linux" ]]; then
  source install/linux.sh
else
  echo "Unsupported OS: $OS"
  exit 1
fi

source install/common.sh
