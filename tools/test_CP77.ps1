. "$((Get-Item $PSScriptRoot).Fullname)\redscript_lint.ps1"

$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName
$VortexRoot = "E:\Vortex Mods\cyberpunk2077\in_world_navigation-4583-0-0-1-1654179063"

$R6Src = "$ProjectRoot\src\redscript\in_world_navigation\*"
$R6Destination = "$VortexRoot\r6\scripts\in_world_navigation"

$ArchiveSrc = "$ProjectRoot\resources\packed\archive\pc\mod\in_world_navigation.archive"
$ArchiveDestination = "$VortexRoot\archive\pc\mod"

$DllSrc = "$ProjectRoot\src\red4ext\build\release\bin\in_world_navigation.dll"
$DllDestination = "$VortexRoot\red4ext\plugins\in_world_navigation"


if ($lastexitcode -eq 0) {
    Copy-Item -Path $R6Src -Destination $R6Destination -Force -Verbose
    Copy-Item -Path $ArchiveSrc -Destination $ArchiveDestination -Force -Verbose
    Copy-Item -Path $DllSrc -Destination $DllDestination -Force -Verbose
    . "E:\Games\Cyberpunk2077\bin\x64\Cyberpunk2077.exe"
}