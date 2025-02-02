#!/bin/bash

# First the essentials

echo "Starting dotfiles setup..."
# apt update && 
#   apt install -y \
#   curl \
#   wget \
#   zsh \
#   jq \
#   tree \
#   neovim \
#   git \
#   tmux \
#   fzf \
#   ripgrep
  #TODO: timezone neovim
# TODO: Export environment and trigger reload
# Homebrew specific packages
# bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# brew install wget
# brew install zsh
# brew install docker
# brew install git 
# brew install jq
# brew install tree
# brew install neovim

# Detect OS
OS=$(uname -s)

install_packages() {
  echo "Installing packages..."
  if [ "$OS" = "Linux" ]; then
    echo "Using Linux"
    if [ -x "$(command -v apt)" ]; then
      echo "Using apt"
      apt update
      apt install -y \
        curl \
        wget \
        zsh \
        jq \
        tree \
        neovim \
        git \
        tmux \
        fzf \
        ripgrep
        # build-essential gcc g++ make cmake \
        # python3 python3-pip python3-venv \
        # nodejs npm
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
      brew install wget
      brew install zsh
      brew install jq tree
      brew install --cask iterm2
      brew install --cask vscode
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

# install_python_tools() {
#   echo "Installing Python tools (Mypy and Ruff)..."
#   pip install --user mypy ruff
# }




install_zsh() {
export RUNZSH=no
export CHSH=no
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

fi
if [ "$SHELL" != "$(which zsh)" ]; then
    chsh -s "$(which zsh)"
fi
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
  # cp ./.vimrc ~/.vimrc
  cp ./.tmux.conf ~/.tmux.conf
  mkdir -p ~/.config/nvim
  cp ./.config/nvim/init.vim ~/.config/nvim/init.vim
  echo "Dotfiles linked successfully."
}

install_neovim_plugins() {
  echo "Installing Neovim plugins..."
  nvim +PlugInstall +qall
  echo "Neovim plugins installed successfully."
}

install_zig_latest() {
  echo "Installing Zig Master branch..."
  bash -c zig_install.sh
  echo "Zig Installed"
}

install_nvim_plug(){
  # Install vim-plug if not already installed
if [ ! -f "${HOME}/.local/share/nvim/site/autoload/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo "${HOME}/.local/share/nvim/site/autoload/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

# Ensure Neovim installs plugins automatically
nvim --headless -c "PlugInstall" -c "qall"

# Fix for Treesitter: Install Treesitter parsers explicitly
# nvim --headless -c "TSUpdate" -c "q"

# Ensure Neovim updates LSP servers (if using Mason or LSP-config)
# nvim --headless -c "MasonInstallAll" -c "q" || echo "Mason not installed, skipping..."

# # Ensure colorschemes are loaded (e.g., tokyonight)
# nvim --headless -c "colorscheme tokyonight" -c "q" || echo "Color scheme issue, check config."
}

main() {
  install_packages
  install_zsh
  link_dotfiles

  install_nvim_plug
  # install_python_tools
  # install_tmux_plugin_manager
  #install_neovim_plugins
  echo "Setup completed successfully!"
}

# main
main
zsh