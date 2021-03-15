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

$ProcessName = (Get-Item $Installer).Basename
"Waiting for process: $ProcessName"
&$Installer /VERYSILENT /LOG=out.txt /SUPPRESSMSGBOXES /SP- /NOCANCEL /NORESTART /IDFVERSION=${IdfVersion}
$InstallerProcess = Get-Process $ProcessName
Sleep 5
# Logs must be watched in separate job, because Inno Setup does not allow to print stdout.
$LogWatcher = Start-Job { Get-Countent ./out.txt -Wait }

# Wait for installer to finish
while (!$InstallerProcess.HasExited) {
    Sleep 5
    Receive-Job $LogWatcher
}
Wait-Process -Id $InstallerProcess.id
Stop-Job $LogWatcher
