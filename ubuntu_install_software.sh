#!/bin/bash
# Bootstrap script: run this on a fresh Ubuntu machine before using chezmoi.
set -e

# Set hidden snap folder and install chezmoi
sudo snap set system experimental.hidden-snap-folder=true
sudo snap install chezmoi --classic

# Install apt packages
sudo apt install -y tmux keychain python3-full python3-virtualenvwrapper ripgrep fd-find openssh-server build-essential make gcc
ssh-import-id-gh haraldan

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

# Install yazi
cargo install --force yazi-build

# Install ouch (archive tool used by yazi)
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
