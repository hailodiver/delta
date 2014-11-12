#stringSearchDir.ps1
#Use: .\stringSearchDir.ps1 <directory> <match term>
#
param($dir, $match)
if(($dir -eq $null) -or ($match -eq $null)){write-host "Instructions for use: .\stringSearchDir.ps1 -dir <directory> -match <match term>"; break}
get-childitem $dir | get-content |  ForEach-Object {if($_ -match $match){write-host $_}}
$dir=$null;$match=$null;
