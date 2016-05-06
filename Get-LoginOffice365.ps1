<#
    .DESCRIPTION
        Log in to Office 365 and download commands
   
    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU
   
    .LINK
        https://github.com/sum-moscow/AAD-sync
#>

Function Get-LoginOffice365 {
    param (
        [parameter(Mandatory = $true)]
        [string] $UserName,

        [parameter(Mandatory = $true)]
        [string] $Password
    )

    $UserCredential = New-Object System.Management.Automation.PsCredential($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))

    $Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection
    Import-PSSession $Session
    Connect-MsolService -Credential $UserCredential 
}
