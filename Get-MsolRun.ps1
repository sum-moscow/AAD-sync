<#
    .DESCRIPTION
       Helper for login AAD

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .LINK
       https://github.com/sum-moscow/AAD-sync
#>

$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Get-LoginOffice365.ps1

#config file
[xml]$CF = Get-Content "$LocalDir\Config.xml"
$C = $CF.cfg

Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password
