$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Import-AllRun.ps1


    Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password



 $adConnector  = "ad.guu.ru"

$aadConnector = "guu.ru - AAD"

 

Import-Module adsync

$c = Get-ADSyncConnector -Name $adConnector

$p = New-Object Microsoft.IdentityManagement.PowerShell.ObjectModel.ConfigurationParameter "Microsoft.Synchronize.ForceFullPasswordSync", String, ConnectorGlobal, $null, $null, $null

$p.Value = 1

$c.GlobalParameters.Remove($p.Name)

$c.GlobalParameters.Add($p)

$c = Add-ADSyncConnector -Connector $c

 

Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $false

Set-ADSyncAADPasswordSyncConfiguration -SourceConnector $adConnector -TargetConnector $aadConnector -Enable $true
