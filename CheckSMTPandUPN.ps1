
$Users = Get-MsolUser -All | select UserPrincipalName,ProxyAddresses

ForEach ($User in $Users) {

    #check only students
    if ($User.UserPrincipalName -notmatch "@edu.guu.ru$"){
        #echo "$($User.UserPrincipalName) skip.."
        continue
    }

    #echo "$($User.UserPrincipalName) checking.."

    $Bad = $false
    if ($User.ProxyAddresses.Count -ne 2) {
        $Bad = $true
    }

    $UPNWithOutDomain = $($User.UserPrincipalName) -replace "@edu.guu.ru"

    ForEach ($ProxyAddress in $User.ProxyAddresses){
            if (($ProxyAddress -ne "SMTP:$($User.UserPrincipalName)") -and
                ($ProxyAddress -notmatch "smtp:$UPNWithOutDomain[\w\-\.]*@guuru.onmicrosoft.com")){
                $Bad = $true
            }
    }


    if ($Bad){
        echo "$($user.UserPrincipalName) -> $($user.ProxyAddresses)"
    }
}