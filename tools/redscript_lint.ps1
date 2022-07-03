$ProjectRoot = (Get-Item $PSScriptRoot).Parent.FullName
$RedscriptCli = "$ProjectRoot\deps\redscript-cli.exe"

$GameLocation = "E:\Games\Cyberpunk2077"
$FinalRedscript = "$GameLocation\r6\cache\final.redscripts.bk"

$Src = "$ProjectRoot\src\redscript"


$pinfo = New-Object System.Diagnostics.ProcessStartInfo
$pinfo.FileName = $RedscriptCli
$pinfo.RedirectStandardError = $true
$pinfo.RedirectStandardOutput = $true
$pinfo.UseShellExecute = $false
$pinfo.Arguments = "lint -s $Src -b $FinalRedscript"
$p = New-Object System.Diagnostics.Process
$p.StartInfo = $pinfo
$p.Start() | Out-Null
$p.WaitForExit()

$stdout = $p.StandardOutput.ReadToEnd()
Write-Host $stdout
if ($stdout.Contains("ERROR")){
    exit 1
}
exit 0