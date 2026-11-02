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
# Lets PipeWire run its audio threads with realtime priority (avoids dropouts)
omarchy-pkg-add rtkit

# Remove unused apps
omarchy-pkg-drop starship webp-pixbuf-loader evince xournalpp imv obs-studio nautilus nautilus-python sushi papers
# Remove unused web apps
omarchy-webapp-remove HEY
omarchy-webapp-remove X
omarchy-webapp-remove "Google Photos"
omarchy-webapp-remove Basecamp
# Omarchy's copy of the imv launcher isn't owned by the package, so it outlives imv
rm -f ~/.local/share/applications/imv.desktop
update-desktop-database ~/.local/share/applications

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
omarchy-pkg-add dolphin dolphin-plugins okular gwenview easyeffects
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
# VA-API over NVDEC, for GPU video decoding in Brave (chezmoi's brave wrapper enables it)
omarchy-pkg-add libva-nvidia-driver

# System configs live in /etc; the repo keeps them under etc/ (ignored by chezmoi)
dotfiles_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Irish English locale
sudo sed -i 's/^#\(en_IE\.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen
sudo install -Dm644 "$dotfiles_dir/etc/locale.conf" /etc/locale.conf

# keyd: Caps Lock is Esc on tap, Ctrl on hold
omarchy-pkg-add keyd
sudo install -Dm644 "$dotfiles_dir/etc/keyd/default.conf" /etc/keyd/default.conf
sudo systemctl enable --now keyd

# Don't suspend on lid close; hypridle suspends after 10 min idle on battery instead.
# chezmoi installs hypridle.conf and the symlink that starts it with the session.
omarchy-pkg-add hypridle
sudo install -Dm644 "$dotfiles_dir/etc/systemd/logind.conf.d/30-lid-no-sleep.conf" /etc/systemd/logind.conf.d/30-lid-no-sleep.conf
sudo systemctl kill -s HUP systemd-logind

# Savitech USB S/PDIF adapter: hardware volume at 100% on plug-in (volume is software-only)
sudo install -Dm644 "$dotfiles_dir/etc/udev/rules.d/91-savitech-spdif-full-volume.rules" /etc/udev/rules.d/91-savitech-spdif-full-volume.rules
sudo udevadm control --reload

# Brother HL-L3240CDW printer driver
omarchy-pkg-aur-add brother-hll3240cdw-bin
# The AUR package skips Brother's postinst link; without it the driver ignores job options and prints everything as Letter
sudo ln -sf /opt/brother/Printers/hll3240cdw/lpd/brprintconf_hll3240cdw /usr/bin/brprintconf_hll3240cdw

# NFS client for the NAS shares automounted via /etc/fstab
omarchy-pkg-add nfs-utils
