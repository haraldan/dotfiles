# Opens $Path as a new tab in the running herdr session and brings its WezTerm
# window to the front. Starts herdr in a new WezTerm window if no client is attached.
# Invoked from the Explorer context menu (see windows_install_software.ps1).
param([Parameter(Mandatory)][string]$Path)

# Explorer passes "C:\" for drive roots, which arrives as C:" (the \" escapes the quote)
$Path = $Path.Trim('"')
if ($Path -match '^[A-Za-z]:$') { $Path += '\' }

herdr tab create --cwd $Path --focus | Out-Null
if ($LASTEXITCODE -ne 0) {
    # No server running: herdr starts one in $Path
    Start-Process wezterm-gui.exe -ArgumentList 'start', '--cwd', "`"$Path`"", '--', 'herdr'
    return
}

# Find an attached client (herdr.exe that isn't the server) and the WezTerm window hosting it
$procs = Get-CimInstance Win32_Process
$client = $procs | Where-Object { $_.Name -eq 'herdr.exe' -and $_.CommandLine -notmatch '\sserver\b' } | Select-Object -First 1
$wezterm = $null
for ($p = $client; $p; $p = $procs | Where-Object ProcessId -eq $p.ParentProcessId) {
    if ($p.Name -eq 'wezterm-gui.exe') { $wezterm = $p; break }
}

if ($wezterm) {
    (New-Object -ComObject WScript.Shell).AppActivate([int]$wezterm.ProcessId) | Out-Null
}
else {
    Start-Process wezterm-gui.exe -ArgumentList 'start', '--cwd', "`"$Path`"", '--', 'herdr'
}
