winget install twpayne.chezmoi
winget install gerardog.gsudo
winget install Microsoft.PowerShell
winget install junegunn.fzf
winget install sxyazi.yazi
winget install Python.Python.3
winget install JesseDuffield.lazygit
winget install wez.wezterm
# Yazi optional dependencies (recommended)
winget install Gyan.FFmpeg 7zip.7zip jqlang.jq oschwartz10612.Poppler sharkdp.fd BurntSushi.ripgrep.MSVC ImageMagick.ImageMagick
winget install Notepad++.Notepad++
winget install Microsoft.PowerToys
winget install AutoHotkey.AutoHotkey
winget install psmux
git clone https://github.com/psmux/psmux-plugins.git "$env:TEMP\psmux-plugins" ; Copy-Item "$env:TEMP\psmux-plugins\ppm" "$env:USERPROFILE\.psmux\plugins\ppm" -Recurse ; Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force

pwsh -Command "Install-Module -Name PSFzf -Scope CurrentUser -Force"
