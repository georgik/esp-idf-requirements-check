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
&$Installer /VERYSILENT /SUPPRESSMSGBOXES /SP- /NOCANCEL /NORESTART /IDFVERSION=${IdfVersion}
$InstallerProcess = Get-Process $ProcessName
Wait-Process -Id $InstallerProcess.id
