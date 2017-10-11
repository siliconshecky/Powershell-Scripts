#This script will uncheck the Do Not Allow Terminal Services Logon for User accounts


Import-Module ActiveDirectory
$out = @()
$searchOU = "OU=Users,OU=whatever,DC=domain,DC=com"
(Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName) | ForEach `
  {
    $userDN = $_ | Select -expandProperty DistinguishedName
    $user = [adsi]"LDAP://$userDN" #this gets the user to equate to the LDAP equivalent
    if($user.AllowLogon -ne 1){
    $user.psbase.invokeSet(“allowLogon”,1) #invokeSet and allowlogon ar eused in conjustion with LDAP because the Attribute is not available with a straight AD query
    $user.CommitChanges() #Commit the changes made to the opbject (pressing apply in the GUI)
    Write-Host "$($user.Name) has been granted access to RDS" -fore green #write the output of the changes to the screen. You could set this up for a CSV output also.
}
  }
