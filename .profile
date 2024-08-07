# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
# add cargo apps to PATH
. "$HOME/.cargo/env"
# # add bob's neovim to PATH
# if [ -d "$HOME/.local/share/bob/nvim-bin" ] ; then
#   PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
# fi
# add Mason's packages to PATH
if [ -d "$HOME/.local/share/nvim/mason/bin/" ] ; then
  PATH="$PATH:$HOME/.local/share/nvim/mason/bin/"
fi
# Cross-compiler path ENV variable
export ARMGCC_DIR=/opt/arm-gnu-toolchain-13.2.Rel1-x86_64-arm-none-eabi/
export XTENSA_TOOLCHAIN_DIR=/opt/hifi4-toolchain/2023_11/RI-2023.11-linux
export XTENSA_LICENSE_FILE=/opt/hifi4-toolchain/iMXRT600SDK.lic

