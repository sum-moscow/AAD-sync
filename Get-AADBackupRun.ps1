<#
    .DESCRIPTION
       This script export (backup) basic user Azure AD (Office 365) parameters to xml

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .REQUIRES
        * global module DashingLogger
   
    .LINK
       https://github.com/sum-moscow/AAD-sync
#>

$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Import-AllRun.ps1

Log-Set -Service "BackupAAD" -Url $C.dashing.url -Token $C.dashing.token 

Log-Begin
Log("Enter to O365 and get commands")
try {
    Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password
} catch {
    Log-Critical("Can't enter to O365") -End
    exit
}

Log("Create backup folder")
$BackupDir = $C.backupPath
$date = Get-Date -Format 'yyyy.MM.dd'

try {
    Set-Location $BackupDir -ErrorAction stop
    New-Item -Type Directory -Name $date -ErrorAction stop
    Set-Location $date -ErrorAction stop
} catch {
    Log-Critical("Can't create backup folder") -End
    exit
}

Log("Get all AAD users")
try {
    $Users = Get-MsolUser -All
} catch {
    Log-Critical("Can't get AAD users")
}

Log("Exporting AAD users to xml...")
$Users | Export-Clixml "MsolUser.xml"

Log("Get all AAD recipients")
try {
    $Recipients = Get-Recipient -ResultSize Unlimited
} catch {
    Log-Critical("Can't get AAD users")
}

Log("Exporting AAD recipients to xml...")
$Recipients | Export-Clixml "MsolRecipients.xml"

Log-End("Backup $($Users.count) users")