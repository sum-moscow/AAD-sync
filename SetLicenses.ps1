<#
.DESCRIPTION
   This script set licenses to Office 365

.AUTHOR    Zubarev Alexander aka Strike (av_zubarev@guu.ru)
.COMPANY   State University of Management aka GUU
   
.LINK
   https://github.com/sum-moscow/AAD-sync
#>

#auth
. "C:\AAD\loginOffice365.ps1"

$users = Get-MsolUser -UnlicensedUsersOnly -All
foreach($user in $users) {
    set-msoluser -userprincipalname $user.UserPrincipalName -usagelocation RU

    # for staff
    if ($user.UserPrincipalName -match "@guu.ru"){
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses "guuru:STANDARDWOFFPACK_FACULTY"
        $365 = New-MsolLicenseOptions -AccountSkuId "guuru:STANDARDWOFFPACK_FACULTY" -DisabledPlans "SHAREPOINTWAC_EDU", "SHAREPOINTSTANDARD_EDU"
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -LicenseOptions $365
        $Prj = New-MsolLicenseOptions -AccountSkuId "guuru:PROJECTONLINE_PLAN_1_FACULTY"
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses "guuru:PROJECTONLINE_PLAN_1_FACULTY" -LicenseOptions $Prj
    }

    # for students
    if ($user.UserPrincipalName -match "@edu.guu.ru"){
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses "guuru:STANDARDWOFFPACK_STUDENT"
        $365 = New-MsolLicenseOptions -AccountSkuId "guuru:STANDARDWOFFPACK_STUDENT" -DisabledPlans "SHAREPOINTWAC_EDU", "SHAREPOINTSTANDARD_EDU"
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -LicenseOptions $365
        $Prj = New-MsolLicenseOptions -AccountSkuId "guuru:PROJECTONLINE_PLAN_1_STUDENT"
        Set-MsolUserLicense -UserPrincipalName $user.UserPrincipalName -AddLicenses "guuru:PROJECTONLINE_PLAN_1_STUDENT" -LicenseOptions $Prj
    }
}

