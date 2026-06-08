# Aliases
function ll { Get-ChildItem -Force $args }

# Yazi shell integration: changes directory on exit
function y {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp -Encoding UTF8
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.ProviderPath) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}

# Ctrl-D to exit (like bash)
Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Alt-E to open Yazi
Set-PSReadLineKeyHandler -Key Alt+e -ScriptBlock {
    [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
    [Microsoft.PowerShell.PSConsoleReadLine]::Insert('y')
    [Microsoft.PowerShell.PSConsoleReadLine]::AcceptLine()
}
