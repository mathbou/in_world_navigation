. "$((Get-Item $PSScriptRoot).Fullname)\VsX64.ps1"

$CMAKE = "C:\Program Files\CMake\bin\cmake"

$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName
$Src = "$ProjectRoot\src\red4ext"
$Build = "$Src\build"

Remove-Item $Build -Recurse
. $CMAKE -E make_directory $Build
Set-Location -Path $Build

. $CMAKE $ProjectRoot -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=RELEASE -T ClangCL
. $CMAKE --build $Build --config Release