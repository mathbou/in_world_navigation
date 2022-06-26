$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName
$RedscriptCli = "$ProjectRoot\deps\redscript-cli.exe"

$GameLocation = "E:\Games\Cyberpunk2077"
$FinalRedscript = "$GameLocation\r6\cache\final.redscripts.bk"

$Src = "$ProjectRoot\src\redscript"

. $RedscriptCli lint -s $Src -b $FinalRedscript