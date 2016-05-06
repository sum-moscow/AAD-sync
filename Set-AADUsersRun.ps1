<#
    .DESCRIPTION
       This script set smt to all aad

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .REQUIRES
        * global module DashingLogger
   
    .LINK
       https://github.com/sum-moscow/AAD-sync
#>


$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Import-AllRun.ps1

Log-Set -Service "Other" -Url $C.dashing.url -Token $C.dashing.token 
Log-Begin

Log("Enter to O365 and get commands")
try {
    Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password
} catch {
    Log-Critical("Can't enter to O365") -End
    exit
}
exit

# Set Regional Configuration for all mailboxes
Get-Mailbox -ResultSize Unlimited | Set-MailboxRegionalConfiguration -Language ru-RU -DateFormat "dd.MM.yyyy" -TimeFormat "HH:mm" -TimeZone "Russian Standard Time" -LocalizeDefaultFolderName


Log-End("End")
