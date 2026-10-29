#!/bin/bash
# Bootstrap script: run this on a fresh Omarchy machine before using chezmoi.
set -e

# AUR builds refuse to run as root, and ~ must be the user's home; sudo is used where needed
if (( EUID == 0 )); then
  echo "Run this as your normal user, not with sudo" >&2
  exit 1
fi

# Update system
sudo pacman -Syu

# Install packages (Omarchy already ships tmux, ripgrep, fd, fzf, lazygit, neovim,
# tree-sitter-cli, unzip, clang, mise and most yazi dependencies)
omarchy-pkg-add chezmoi keychain openssh sshpass base-devel rustup

# Remove starship so Omarchy's bash defaults keep the plain bash prompt
omarchy-pkg-drop starship

# Install yazi
omarchy-pkg-add yazi
# Yazi optional dependencies
omarchy-pkg-add ffmpeg jq poppler imagemagick zoxide wl-clipboard file resvg ouch

# Terminals
omarchy-pkg-add ghostty
omarchy-pkg-aur-add wezterm-nightly-bin
# Font used by the WezTerm config
omarchy-pkg-add ttf-cascadia-mono-nerd

# Desktop apps (chezmoi's EasyEffects drop-in delays its autostart until the tray is up)
omarchy-pkg-add dolphin dolphin-plugins easyeffects
omarchy-pkg-aur-add neofetch jellyfin-desktop

# TPM (Tmux Plugin Manager)
if [ ! -d ~/.tmux/plugins/tpm ] || [ -z "$(ls -A ~/.tmux/plugins/tpm)" ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Third-party shell plugins; chezmoi's shell.json places them on the bar
for plugin in \
  codefriendly.nightman=https://github.com/codefriendly/omarchy-nightman.git \
  crmne.hyprmoncfg=https://github.com/crmne/omarchy-hyprmoncfg.git \
  io.github.thetrueferret.decent-workspaces=https://github.com/TheTrueFerret/omarchy-decent-workspaces.git; do
  [ -d ~/.config/omarchy/plugins/"${plugin%%=*}" ] || omarchy-plugin-add "${plugin#*=}" --yes
done

# Move Omarchy's LazyVim config aside so chezmoi's nvim config starts clean
if [ -d ~/.config/nvim ] && [ ! -d ~/.config/nvim.omarchy ]; then
  mv ~/.config/nvim ~/.config/nvim.omarchy
fi

# Same for tmux: chezmoi's tmux config replaces Omarchy's ~/.config/tmux/tmux.conf
if [ -d ~/.config/tmux ] && [ ! -d ~/.config/tmux.omarchy ]; then
  mv ~/.config/tmux ~/.config/tmux.omarchy
fi

# Brave as default browser
omarchy-pkg-present brave-bin || omarchy-install-browser brave
omarchy-default-browser brave

# System configs live in /etc; the repo keeps reference copies under dot_config
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# keyd: Caps Lock is Esc on tap, Ctrl on hold
omarchy-pkg-add keyd
sudo install -Dm644 "$dotfiles_dir/dot_config/keyd/default.conf" /etc/keyd/default.conf
sudo systemctl enable --now keyd

# Don't suspend on lid close; hypridle suspends after 10 min idle on battery instead.
# chezmoi installs hypridle.conf and the symlink that starts it with the session.
omarchy-pkg-add hypridle
sudo install -Dm644 "$dotfiles_dir/dot_config/systemd/logind.conf.d/30-lid-no-sleep.conf" /etc/systemd/logind.conf.d/30-lid-no-sleep.conf
sudo systemctl kill -s HUP systemd-logind

# NFS client for the NAS shares automounted via /etc/fstab
omarchy-pkg-add nfs-utils
