$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName

Write-Host "Download redscript-cli"
Invoke-WebRequest -Uri "https://github.com/jac3km4/redscript/releases/download/v0.5.4/redscript-cli.exe" `
-OutFile "$ProjectRoot\deps\redscript-cli.exe"

#git -C $ProjectRoot submodule sync --recursive
git -C $ProjectRoot submodule update --recursive --init

git -C "$ProjectRoot\deps\red4ext.sdk" checkout f3954c1
git -C "$ProjectRoot\deps\spdlog" checkout v1.10.0

. "$((Get-Item $PSScriptRoot).Fullname)\build_spdlog.ps1"