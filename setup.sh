#!/bin/bash

# First the essentials

echo "Starting dotfiles setup..."

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
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# Detect OS
OS=$(uname -s)

install_neovim() {
  echo "Installing Neovim..."
  if [ "$OS" = "Linux" ]; then
    if [ -x "$(command -v apt)" ]; then
      sudo apt update
      sudo apt install -y neovim
    elif [ -x "$(command -v dnf)" ]; then
      sudo dnf install -y neovim
    elif [ -x "$(command -v pacman)" ]; then
      sudo pacman -Syu neovim --noconfirm
    else
      echo "Unsupported Linux package manager. Please install Neovim manually."
      return 1
    fi
  elif [ "$OS" = "Darwin" ]; then
    if [ -x "$(command -v brew)" ]; then
      brew install neovim
    else
      echo "Homebrew not found. Please install Homebrew and rerun the script."
      return 1
    fi
  else
    echo "Unsupported OS: $OS. Please install Neovim manually."
    return 1
  fi
  echo "Neovim installed successfully."
}

install_python_tools() {
  echo "Installing Python tools (Mypy and Ruff)..."
  pip install --user mypy ruff
}

install_tmux_plugin_manager() {
  echo "Installing Tmux Plugin Manager (TPM)..."
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    echo "TPM installed successfully."
  else
    echo "TPM already installed."
  fi
}

link_dotfiles() {
  echo "Linking dotfiles..."
  ln -sf ~/dotfiles/.vimrc ~/.vimrc
  ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf
  mkdir -p ~/.config/nvim
  ln -sf ~/dotfiles/.config/nvim/init.vim ~/.config/nvim/init.vim
  ln -sf ~/dotfiles/.mypy.ini ~/.mypy.ini
  ln -sf ~/dotfiles/pyproject.toml ~/pyproject.toml
  echo "Dotfiles linked successfully."
}

install_neovim_plugins() {
  echo "Installing Neovim plugins..."
  nvim +PlugInstall +qall
  echo "Neovim plugins installed successfully."
}

main() {
  install_neovim
  install_python_tools
  install_tmux_plugin_manager
  link_dotfiles
  install_neovim_plugins
  echo "Setup completed successfully!"
}

main
