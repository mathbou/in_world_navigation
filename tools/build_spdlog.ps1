. "$((Get-Item $PSScriptRoot).Fullname)\VsX64.ps1"

$CMAKE = "C:\Program Files\CMake\bin\cmake"
$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName
$Src = "$ProjectRoot\deps\spdlog"
$Build = "$Src\build"

Remove-Item $Build -Recurse
. $CMAKE -E make_directory $Build
Set-Location -Path $Build

. $CMAKE $Src -A x64 -T ClangCL
. $CMAKE --build $Build --config RELEASE