<#
    .DESCRIPTION
       This script assign licenses to users of the Office 365

    .AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
    .COMPANY   State University of Management aka GUU

    .REQUIRES
        * global module DashingLogger
   
    .LINK
       https://github.com/sum-moscow/AAD-sync
#>


$LocalDir = $MyInvocation.MyCommand.Definition | split-path -parent
. $LocalDir\Import-AllRun.ps1

Log-Set -Service "LicensingAAD" -Url $C.dashing.url -Token $C.dashing.token 
Log-Begin

Log("Enter to O365 and get commands")
try {
    Get-LoginOffice365 -UserName $C.AAD.username -Password $C.AAD.password
} catch {
    Log-Critical("Can't enter to O365") -End
}


Log("Get unlicensed users")
$Users = Get-MsolUser -UnlicensedUsersOnly -All
$Count = $($Users.count)

Log("Licensing $Count users ")
foreach($User in $Users) {
    $UPN = $User.UserPrincipalName

    # only UserMailBox (skip shared mailbox)
    # problem with catch in Get-Recipient
    $Mailbox = Get-Recipient -Identity $UPN
    if ($Mailbox) {
        if ($Mailbox.RecipientTypeDetails -ne "UserMailBox"){
            $Count--
            continue
        }
    }

    $User | Set-MsolUser -UsageLocation RU

    $Licenses = @{}

    if ($UPN -match "@guu.ru"){
        $License365 = "guuru:STANDARDWOFFPACK_FACULTY"
        $LicensePrj = "guuru:PROJECTONLINE_PLAN_1_FACULTY"
        $LicenseProPlus = "guuru:STANDARDWOFFPACK_IW_FACULTY"
    } elseif ($UPN -match "@edu.guu.ru") {
        $License365 = "guuru:STANDARDWOFFPACK_STUDENT"
        $LicensePrj = "guuru:PROJECTONLINE_PLAN_1_STUDENT"
        $LicenseProPlus = "guuru:STANDARDWOFFPACK_IW_STUDENT"
    } else {
        Log-Warning("User with strange UPN: $UPN")
        continue
    }

    $Licenses.Add($License365,@{"License"=$License365})
    $Licenses.Add($LicensePrj,@{"License"=$LicensePrj})
    $Licenses.Add($LicenseProPlus,@{"License"=$LicenseProPlus})
     
    $365 = New-MsolLicenseOptions -AccountSkuId $License365 -DisabledPlans "SHAREPOINTWAC_EDU", "SHAREPOINTSTANDARD_EDU"
    $Prj = New-MsolLicenseOptions -AccountSkuId $LicensePrj
    $ProPlus = New-MsolLicenseOptions -AccountSkuId $LicenseProPlus -DisabledPlans "YAMMER_EDU","SHAREPOINTWAC_EDU","SHAREPOINTSTANDARD_EDU","EXCHANGE_S_STANDARD","MCOSTANDARD"
                                                                    
    $Licenses[$License365].Add("Options",$365)
    $Licenses[$LicensePrj].Add("Options",$Prj)
    $Licenses[$LicenseProPlus].Add("Options",$ProPlus)
    
    foreach($License in $Licenses.GetEnumerator()){
        $L = $License.Value
        try {
            $User | Set-MsolUserLicense -AddLicenses $L.License -LicenseOptions $L.Options
            Log("License $($L.License) assigned to $UPN")
        } catch {
            Log-Warning("Can't set $($L.License) to $UPN")
        }
    }  
}

# Very long
#Log("Count all licensed users")
#$LicensedTotal = (Get-MsolUser -All | Where {$_.IsLicensed -eq "true" }).count 

Log-End("Licensed $Count users (at last run)`nTotal: $LicensedTotal")
