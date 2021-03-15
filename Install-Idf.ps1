[CmdletBinding()]
param (
    [Parameter()]
    [String]
    $Installer="./installer.exe",
    [String]
    $IdfVersion = "v4.2"
)

"Configuration:"
"* Installer = $Installer"
"* IdfVersion = $IdfVersion"

$Directory = (Get-Location).Path
$LogFile = Join-Path -Path $Directory -ChildPath out.txt
$ProcessName = (Get-Item $Installer).Basename
"Waiting for process: $ProcessName"
&$Installer /VERYSILENT /LOG=$LogFile /SUPPRESSMSGBOXES /SP- /NOCANCEL /NORESTART /IDFVERSION=${IdfVersion}
$InstallerProcess = Get-Process $ProcessName
Sleep 5
# Logs must be watched in separate job, because Inno Setup does not allow to print stdout.
$LogWatcher = Start-Job -ArgumentList $LogFile -ScriptBlock {
    Param($LogFile)
    Get-Content -Path $LogFile -Wait
}

# Wait for installer to finish
while (!$InstallerProcess.HasExited) {
    Sleep 5
    Receive-Job $LogWatcher -Keep
}
Wait-Process -Id $InstallerProcess.id
Stop-Job $LogWatcher
