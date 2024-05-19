#!/bin/bash

# First the essentials
# 1. Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# TODO: Export environment and trigger reload
# Homebrew specific packages
brew install wget
brew install --cask iterm2
brew install zig
brew install zsh
brew install docker
brew install git 
brew install jq
brew install tree
brew install --cask vscode
brew install neovim

git clone https://github.com/NvChad/starter ~/.config/nvim && nvim
cp -r ./nvim ~/.config/

sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
