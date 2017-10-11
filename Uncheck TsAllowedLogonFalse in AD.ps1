Import-Module ActiveDirectory
$out = @()
$searchOU = "OU=Users,OU=whatever,DC=domain,DC=com"
(Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName) | ForEach `
  {
    $userDN = $_ | Select -expandProperty DistinguishedName
    $user = [adsi]"LDAP://$userDN"
    if($user.AllowLogon -ne 1){
    $user.psbase.invokeSet(“allowLogon”,1)
    $user.CommitChanges()
    Write-Host "$($user.Name) has been granted access to RDS" -fore green
}
  }
