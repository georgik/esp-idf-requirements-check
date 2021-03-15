[CmdletBinding()]
param (
    [Parameter()]
    [string]$IdfPath = "C:/Users/runneradmin/Desktop/esp-idf"
)

Set-Location "${IdfPath}"

# Timeout is necessary to fix the problem when installer is writing some final files
# it seems that installer exits, but locks were not released yet
Start-Sleep -s 5

$WSShell = New-Object -comObject WScript.Shell
$Shortcut = $WSShell.CreateShortcut('C:/Users/runneradmin/Desktop/ESP-IDF 4.2 CMD.lnk')
$Arguments = $Shortcut.Arguments -replace "/k ", "/c '"
$Command = $Shortcut.TargetPath + ' ' + $Arguments -replace '""', '"'
$Command += " && cd examples\get-started\blink\ && idf.py build'"
Invoke-Expression -Command $Command
