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


ForEach ($User in $Users){
    echo "$($Users.IndexOf($User)+1) of $($Users.count)"
    Set-MsolUser -UserPrincipalName $User.UserPrincipalName -ImmutableID "$null"
}
