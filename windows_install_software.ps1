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
git clone https://github.com/psmux/psmux-plugins.git "$env:TEMP\psmux-plugins" ; Copy-Item "$env:TEMP\psmux-plugins\ppm" "$env:USERPROFILE\.psmux\plugins\ppm" -Recurse -Force ; Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force

pwsh -Command "Install-Module -Name PSFzf -Scope CurrentUser -Force"

# Install CaskaydiaMono Nerd Font
$fontZip = "$env:TEMP\CaskaydiaMono.zip"
$fontDir = "$env:TEMP\CaskaydiaMono"
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip" -OutFile $fontZip
Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
gsudo {
    foreach ($font in Get-ChildItem -Path $args[0] -Filter "*.ttf") {
        $shell = New-Object -ComObject Shell.Application
        $shell.Namespace(0x14).CopyHere($font.FullName)
    }
} -args $fontDir
Remove-Item $fontZip, $fontDir -Recurse -Force
