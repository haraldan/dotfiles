winget install twpayne.chezmoi
winget install gerardog.gsudo
winget install Microsoft.PowerShell
winget install psmux
winget install junegunn.fzf
winget install sxyazi.yazi
winget install Python.Python.3
winget install JesseDuffield.lazygit
winget install wez.wezterm
# Yazi optional dependencies (recommended)
winget install Gyan.FFmpeg 7zip.7zip jqlang.jq oschwartz10612.Poppler sharkdp.fd BurntSushi.ripgrep.MSVC ImageMagick.ImageMagick

pwsh -Command "Install-Module -Name PSFzf -Scope CurrentUser -Force"
