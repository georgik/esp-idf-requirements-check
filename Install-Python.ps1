
param (
    [string]$PythonVersion="3.8.6",
    [string]$PythonPatch="",
    [string]$PythonDir="python3"
)

Invoke-WebRequest -Uri "https://www.python.org/ftp/python/${PythonVersion}/python-${PythonVersion}${PythonPatch}-amd64.exe" -Out "python-amd64.exe"
.\python-amd64.exe /quiet /passive TargetDir=${pwd}\${PythonDir}
$InstallerProcess = Get-Process python-amd64
Wait-Process -Id $InstallerProcess.id
