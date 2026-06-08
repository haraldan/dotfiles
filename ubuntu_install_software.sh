#!/bin/bash
# Bootstrap script: run this on a fresh Ubuntu machine before using chezmoi.
set -e

# Set hidden snap folder and install chezmoi
sudo snap set system experimental.hidden-snap-folder=true
sudo snap install chezmoi --classic

# Install apt packages
sudo apt install -y tmux keychain python3-full python3-virtualenvwrapper ripgrep fd-find

# Install lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name"' | sed 's/.*"v\([^"]*\)".*/\1/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar -xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
rm lazygit lazygit.tar.gz

# Install rustup and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install bob (Neovim version manager) and Neovim
cargo install bob-nvim
bob install stable
bob use stable

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install yazi
cargo install --force yazi-build

# Install ouch (archive tool used by yazi)
cargo install ouch

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/HEAD/install.sh | bash
