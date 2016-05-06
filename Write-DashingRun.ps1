<#
    .DESCRIPTION
       Helper for login AAD only

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .LINK
       https://github.com/sum-moscow/AAD-sync
#>

echo "!!!"
echo $args[0]
$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Import-AllRun.ps1

Set-Dashing -Service $args[0] -Url $C.dashing.url -Token $C.dashing.token 
echo "%%%"
Write-Dashing -Status $args[1] -Message $args[2]