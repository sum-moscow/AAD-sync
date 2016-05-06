<#
    .DESCRIPTION
       This script save last loggon date all users of the Office 365
       to csv file in local directory.

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
#try {
#    Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password 
#} catch {
#    Log-Critical("Can't enter to O365") -End
#    exit
#}

Log("Get all users")
#$Users = Get-MsolUser -All -DomainName edu.guu.ru | Where-Object { $_.LastDirSyncTime -ne $null }
$Users = Get-MsolUser -All -DomainName edu.guu.ru
Log("Fetching $($Users.count) users ")

$ExportCSV = @()

foreach($User in $Users) {
    echo "$($Users.IndexOf($User)+1) of $($Users.count)"
    $UPN = $User.UserPrincipalName

    
    if ((Get-Recipient -Identity $UPN).RecipientTypeDetails -eq "SharedMailbox"){
        continue    
    }

    $MbxStats = Get-MailboxStatistics $UPN
    $MbxRecipient = Get-Recipient -Identity $UPN

    $Merged = @{UPN=$UPN
        DisplayName=$MbxStats.DisplayName
        LastLogonTime=$MbxStats.LastLogonTime
        RecipientTypeDetails = $MbxRecipient.RecipientTypeDetails 
    }
    
    $ExportCSV+= New-Object PSObject -Property $Merged
}

$ExportCSV | Export-Csv -Encoding UTF8 -Delimiter ';' -NoTypeInformation -Path MsolUsers.csv