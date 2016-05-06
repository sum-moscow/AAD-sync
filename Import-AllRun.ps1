<#
    .DESCRIPTION
       Helper for import

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .LINK
       https://github.com/sum-moscow/AAD-sync
#>


. $LocalDir\Load-Module.ps1
. $LocalDir\Get-LoginOffice365.ps1

#config file
[xml]$CF = Get-Content "$LocalDir\Config.xml"
$C = $CF.cfg

if (!(Load-Module DashingLogger)){
    Write-Error "Module DashingLogger must be installed"
    exit  
}
