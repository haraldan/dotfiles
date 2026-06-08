#!/bin/bash
# Bootstrap script: run this on a fresh Ubuntu machine before using chezmoi.
set -e

# Set hidden snap folder and install chezmoi
sudo snap set system experimental.hidden-snap-folder=true
sudo snap install chezmoi --classic

# Install rustup and cargo
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

# Install yazi
cargo install --force yazi-build
