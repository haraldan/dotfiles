#!/bin/bash
# Bootstrap script: run this on a fresh Ubuntu machine before using chezmoi.
set -e

# Set hidden snap folder and install chezmoi
sudo snap set system experimental.hidden-snap-folder=true
sudo snap install chezmoi --classic

# Install apt packages
sudo apt update
sudo apt upgrade
sudo apt install -y tmux keychain python3-full python3-virtualenvwrapper ripgrep fd-find openssh-server build-essential libclang-dev sshpass unzip
ssh-import-id-gh haraldan
sudo systemctl enable ssh
sudo systemctl start ssh

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm lazygit lazygit.tar.gz

# Install rustup and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup update

# Install bob (Neovim version manager) and Neovim
cargo install bob-nvim
bob install stable
bob use stable
cargo install --locked tree-sitter-cli

# Install yazi
which yazi &>/dev/null || cargo install yazi-build
# Yazi optional dependencies
sudo apt install -y ffmpeg jq poppler-utils imagemagick zoxide xclip file
cargo install resvg
cargo install ouch

# TPM (Tmux Plugin Manager)
if [ ! -d ~/.tmux/plugins/tpm ] || [ -z "$(ls -A ~/.tmux/plugins/tpm)" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Install fzf
if [ ! -d ~/.fzf ] || [ -z "$(ls -A ~/.fzf)" ]; then
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
fi

# Install nvm and Node.js LTS
if [ ! -d ~/.nvm ]; then
  NVM_VERSION=$(curl -s "https://api.github.com/repos/nvm-sh/nvm/releases/latest" | grep '"tag_name"' | sed 's/.*"\(v[^"]*\)".*/\1/')
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm use --lts
