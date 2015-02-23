<#
.DESCRIPTION
   Log in to Office 365 and download commands
   
.AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
.COMPANY   State University of Management aka GUU
   
.LINK
   https://github.com/sum-moscow/AAD-sync
#>


#config file
Set-Location ($MyInvocation.MyCommand.Definition | split-path -parent) #move to cur dir
[xml]$CF = Get-Content "Config.xml"
$C = $CF.cfg

$UserCredential = New-Object System.Management.Automation.PsCredential("$($C.AAD.username)",(ConvertTo-SecureString "$($C.AAD.password)" -AsPlainText -Force))

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
Import-PSSession $Session
Connect-MsolService -Credential $UserCredential 
