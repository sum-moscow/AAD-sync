
Get-MsolUser -ALL | select UserPrincipalName,ImmutableId | Export-Csv -Encoding utf8 -Path c:\list_user.csv