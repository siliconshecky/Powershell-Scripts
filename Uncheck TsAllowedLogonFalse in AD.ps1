# This script removes the checkmark from the Do Not Allow Terminal Services Logon box in AD
# From all users in a OU.
Import-Module ActiveDirectory
$out = @()
$searchOU = "OU=Users,OU=whatever,DC=domain,DC=com"
(Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName) | ForEach `
  {
    $userDN = $_ | Select -expandProperty DistinguishedName
    $user = [adsi]"LDAP://$userDN" #get user information from LDAP since the attribute is not accessible from AD
    if($user.AllowLogon -ne 1){
    $user.psbase.invokeSet(“allowLogon”,1) #Change the attribute to allow logon from do not allow
    $user.CommitChanges()
    Write-Host "$($user.Name) has been granted access to RDS" -fore green
}
  }
