<#
.DESCRIPTION
   This script export (backup) basic user Azure AD (Office 365) parameters to xml

.AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
.COMPANY   State University of Management aka GUU
   
.LINK
   https://github.com/sum-moscow/AAD-sync
#>

. "C:\AAD\loginOffice365.ps1"

#to backup dir
$BackupDir = $C.backupPath
$date = Get-Date -Format 'yyyy.MM.dd'
Set-Location $BackupDir
New-Item -Type Directory -Name $date
Set-Location $date

Get-MsolUser -all | Export-Clixml "MsolUser.xml"