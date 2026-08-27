#Requires -RunAsAdministrator
# Run from an elevated PowerShell session. gsudo gets installed, but is not used here.
# Use -DryRun to see what would be installed without changing anything.
param([switch]$DryRun)

# Installs $Id unless a program named $Name is already present. The check is by
# display name, not by package id, because Company Portal (Intune) deploys under
# its own ARP id, e.g. "neoPackage Igor Pavlov 7-Zip" / ARP\Machine\X64\{0428C8DE-...}
function Install-App {
    param([string]$Name, [string]$Id, [string]$Options = '')

    winget list --name $Name --disable-interactivity | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[installed]     $Name" -ForegroundColor DarkGray
        return
    }
    if ($DryRun) {
        Write-Host "[would install] $Name  ->  winget install $Id $Options" -ForegroundColor Yellow
        return
    }

    Write-Host "[installing]    $Name" -ForegroundColor Cyan
    $extra = @($Options -split '\s+' | Where-Object { $_ })
    winget install $Id @extra
}

# Enable Developer Mode (allows symlink creation without elevation, needed for winget portable app links)
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock"
$devMode = (Get-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -ErrorAction SilentlyContinue).AllowDevelopmentWithoutDevLicense
if ($devMode -eq 1) {
    Write-Host "[enabled]       Developer Mode" -ForegroundColor DarkGray
}
elseif ($DryRun) {
    Write-Host "[would enable]  Developer Mode" -ForegroundColor Yellow
}
else {
    Write-Host "[enabling]      Developer Mode" -ForegroundColor Cyan
    if (-not (Test-Path $regPath)) {
        New-Item -Path $regPath -Force | Out-Null
    }
    Set-ItemProperty -Path $regPath -Name "AllowDevelopmentWithoutDevLicense" -Value 1 -Type DWord
}

# Machine scope software.
# Explicit --installer-type: otherwise winget resolves some of these to an msix or
# portable installer that does not land in C:\Program Files. --interactive shows the
# vendor GUI so install paths/options can be confirmed.
Install-App 'PowerShell'  'Microsoft.PowerShell'      '--scope machine --installer-type wix --interactive'
Install-App 'AutoHotkey'  'AutoHotkey.AutoHotkey'     '--scope machine --installer-type exe'
Install-App 'REAPER'      'Cockos.REAPER'             '--scope machine --installer-type exe --interactive'
Install-App 'Brave'       'Brave.Brave'               '--scope machine --installer-type exe --interactive'
Install-App 'foobar2000'  'PeterPawlowski.foobar2000' '--scope machine --installer-type nullsoft --interactive'
Install-App 'Obsidian'    'Obsidian.Obsidian'         '--scope machine --installer-type nullsoft --interactive'
Install-App 'VcXsrv'      'marha.VcXsrv'              '--scope machine --installer-type nullsoft --interactive'
Install-App 'gsudo'       'gerardog.gsudo'            '--scope machine --installer-type wix --interactive'
Install-App 'Notepad++'   'Notepad++.Notepad++'       '--scope machine --installer-type wix --interactive'
Install-App '7-Zip'       '7zip.7zip'                 '--scope machine --installer-type wix --interactive'
Install-App 'draw.io'     'JGraph.Draw'               '--scope machine --installer-type wix --interactive'
Install-App 'PowerToys'   'Microsoft.PowerToys'       '--scope machine --installer-type burn --interactive'
Install-App 'Audacity'    'Audacity.Audacity'         '--scope machine --installer-type inno --interactive'
# plain MSI, no options in the wizard, and it registers the sshd/ssh-agent services
Install-App 'OpenSSH'     'Microsoft.OpenSSH.Preview' '--scope machine --installer-type msi --silent'

# User scope software (portable zips, linked from winget's per-user Links dir)
Install-App 'chezmoi'      'twpayne.chezmoi'
Install-App 'fzf'          'junegunn.fzf'
Install-App 'Yazi'         'sxyazi.yazi'
Install-App 'lazygit'      'JesseDuffield.lazygit'
# Twinkle Tray has no machine-scope installer
Install-App 'Twinkle Tray' 'xanderfrangos.twinkletray'

# Yazi optional dependencies (recommended)
Install-App 'FFmpeg'       'Gyan.FFmpeg'
Install-App 'jq'           'jqlang.jq'
Install-App 'Poppler'      'oschwartz10612.Poppler'
Install-App 'fd'           'sharkdp.fd'
Install-App 'RipGrep'      'BurntSushi.ripgrep.MSVC'
Install-App 'ImageMagick'  'ImageMagick.ImageMagick'

# Refresh PATH so the freshly installed pwsh is found by the PSFzf call below
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

if (-not (Get-Command pwsh -ErrorAction SilentlyContinue)) {
    Write-Warning "pwsh not found on PATH - skipped PSFzf."
}
elseif ($DryRun) {
    # -ListAvailable must run inside pwsh: only it can see its own module path
    pwsh -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host '[installed]     PSFzf' -ForegroundColor DarkGray } else { Write-Host '[would install] PSFzf  ->  Install-Module PSFzf -Scope CurrentUser' -ForegroundColor Yellow }"
}
else {
    pwsh -NoProfile -Command "if (Get-Module -ListAvailable -Name PSFzf) { Write-Host '[installed]     PSFzf' -ForegroundColor DarkGray } else { Write-Host '[installing]    PSFzf' -ForegroundColor Cyan; Install-Module -Name PSFzf -Scope CurrentUser -Force }"
}

# Install CaskaydiaMono Nerd Font
Add-Type -AssemblyName System.Drawing
$installedFonts = (New-Object System.Drawing.Text.InstalledFontCollection).Families.Name
if ($installedFonts | Where-Object { $_ -like "CaskaydiaMono*" }) {
    Write-Host "[installed]     CaskaydiaMono Nerd Font" -ForegroundColor DarkGray
}
elseif ($DryRun) {
    Write-Host "[would install] CaskaydiaMono Nerd Font  ->  download CascadiaMono.zip, install into %LOCALAPPDATA%\Microsoft\Windows\Fonts" -ForegroundColor Yellow
}
else {
    Write-Host "[installing]    CaskaydiaMono Nerd Font - downloading..." -ForegroundColor Cyan
    $fontZip = "$env:TEMP\CaskaydiaMono.zip"
    $fontDir = "$env:TEMP\CaskaydiaMono"
    Invoke-WebRequest -UseBasicParsing -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip" -OutFile $fontZip
    Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
    # Shell namespace 0x14 is the Fonts folder. On Windows 10 1809+ this installs
    # per-user (%LOCALAPPDATA%\Microsoft\Windows\Fonts + HKCU) even when elevated.
    # Flags 4 + 16 = no progress dialog, answer "Yes to All" to overwrite prompts.
    $userFonts = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    $shell = New-Object -ComObject Shell.Application
    $fontsFolder = $shell.Namespace(0x14)
    $ttf = Get-ChildItem -Path $fontDir -Filter "*.ttf"
    Write-Host "                installing $($ttf.Count) font files into $userFonts..." -ForegroundColor Cyan
    foreach ($font in $ttf) {
        $fontsFolder.CopyHere($font.FullName, 20)
    }

    # CopyHere is asynchronous - wait for it before deleting the source files.
    # Give up after 60s so a stuck copy can never hang the script.
    $deadline = (Get-Date).AddSeconds(60)
    do {
        $missing = @($ttf | Where-Object { -not (Test-Path (Join-Path $userFonts $_.Name)) })
        if (-not $missing) { break }
        Start-Sleep -Milliseconds 500
    } while ((Get-Date) -lt $deadline)

    if ($missing) {
        Write-Warning "$($missing.Count) of $($ttf.Count) font files did not appear in $userFonts - leaving $fontDir in place."
    }
    else {
        Remove-Item $fontZip, $fontDir -Recurse -Force
        Write-Host "                CaskaydiaMono Nerd Font installed" -ForegroundColor Cyan
    }
}

foreach ($svc in 'sshd', 'ssh-agent') {
    $service = Get-Service -Name $svc -ErrorAction SilentlyContinue
    if (-not $service) {
        Write-Warning "Service '$svc' not found - is OpenSSH installed?"
    }
    elseif ($DryRun) {
        Write-Host "[would config]  service '$svc' (now: $($service.StartType), $($service.Status))  ->  Automatic + restart" -ForegroundColor Yellow
    }
    else {
        Write-Host "[configuring]   service '$svc' - startup Automatic, restarting" -ForegroundColor Cyan
        Set-Service -Name $svc -StartupType Automatic
        Restart-Service -Name $svc -Force
    }
}

# Restore old context menu (per-user: applies to the account running this session).
# Only touch it when not already set, so Explorer isn't restarted on every run.
$clsid = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
$default = if (Test-Path $clsid) { (Get-Item $clsid).GetValue('') } else { $null }
if ($default -eq '') {
    Write-Host "[configured]    old context menu" -ForegroundColor DarkGray
}
elseif ($DryRun) {
    Write-Host "[would config]  old context menu  ->  set CLSID default value, restart Explorer" -ForegroundColor Yellow
}
else {
    Write-Host "[configuring]   old context menu - restarting Explorer" -ForegroundColor Cyan
    reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve | Out-Null
    Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
    Start-Sleep -Seconds 2
    if (-not (Get-Process explorer -ErrorAction SilentlyContinue)) { Start-Process explorer }
}

Write-Host "`nDone." -ForegroundColor Green
if ($DryRun) {
    Write-Host "Dry run: nothing was changed. Re-run without -DryRun to apply." -ForegroundColor Yellow
}
