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
winget install Cockos.REAPER
winget install PeterPawlowski.foobar2000
winget install Obsidian.Obsidian
winget install Audacity.Audacity
winget install JGraph.Draw
winget install Brave.Brave
winget install Inkscape.Inkscape
winget install VcXsrv.VcXsrv
winget install Microsoft.OpenSSH.Preview
ssh-import-id-gh haraldan
winget install psmux
$psmuxPluginsDir = "$env:USERPROFILE\.psmux\plugins\ppm"
if (-not (Test-Path $psmuxPluginsDir) -or (Get-ChildItem $psmuxPluginsDir -Force | Measure-Object).Count -eq 0) {
    git clone https://github.com/psmux/psmux-plugins.git "$env:TEMP\psmux-plugins" ; Copy-Item "$env:TEMP\psmux-plugins\ppm" $psmuxPluginsDir -Recurse -Force ; Remove-Item "$env:TEMP\psmux-plugins" -Recurse -Force
}

# Add OpenSSH Preview to the front of machine PATH so it takes precedence over the built-in
$sshPath = "$env:ProgramFiles\OpenSSH"
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
if ($machinePath -notlike "*$sshPath*") {
    gsudo { [System.Environment]::SetEnvironmentVariable("Path", "$($args[0]);$([System.Environment]::GetEnvironmentVariable('Path','Machine'))", "Machine") } -args $sshPath
}

# Refresh PATH so winget-installed binaries are available in this session
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

pwsh -Command "Install-Module -Name PSFzf -Scope CurrentUser -Force"

# Install CaskaydiaMono Nerd Font
$installedFonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
if (-not ($installedFonts -like "Cascadia Mono*")) {
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
}
