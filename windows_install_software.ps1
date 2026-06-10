winget install twpayne.chezmoi --source winget
winget install gerardog.gsudo --source winget
winget install Microsoft.PowerShell --source winget --installer-type wix
winget install junegunn.fzf --source winget
winget install sxyazi.yazi --source winget
winget install Python.Python.3 --source winget
winget install JesseDuffield.lazygit --source winget
winget install wez.wezterm --source winget
# Yazi optional dependencies (recommended)
winget install Gyan.FFmpeg 7zip.7zip jqlang.jq oschwartz10612.Poppler sharkdp.fd BurntSushi.ripgrep.MSVC ImageMagick.ImageMagick --source winget
winget install Notepad++.Notepad++ --source winget
winget install Microsoft.PowerToys --source winget
winget install AutoHotkey.AutoHotkey --source winget
winget install Cockos.REAPER --source winget
winget install PeterPawlowski.foobar2000 --source winget
winget install Obsidian.Obsidian --source winget
winget install Audacity.Audacity --source winget
winget install JGraph.Draw --source winget
winget install Brave.Brave --source winget
winget install marha.VcXsrv --source winget
winget install Microsoft.OpenSSH.Preview --source winget
winget install xanderfrangos.twinkletray --source winget

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
Add-Type -AssemblyName System.Drawing
$installedFonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
if (-not ($installedFonts -like "CaskaydiaMono*")) {
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

gsudo {
    Set-Service -Name sshd -StartupType Automatic; Restart-Service sshd
    Set-Service -Name ssh-agent -StartupType Automatic; Start-Service ssh-agent
	# Restore old context menu
	reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
	Stop-Process -Name explorer -Force; Start-Process explorer
}