$VS="C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\Tools"
Set-Location "$VS"
. .\Launch-VsDevShell.ps1 -HostArch amd64 -Arch amd64 -VsInstallationPath .
