# This script will go through and find AD Users who have the
# Do Not allow Login to terminal sessions box checked

Import-Module ActiveDirectory
$out = @()
$searchOU = "OU=Users,OU=whatever,DC=domain,DC=com"
(Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName) | ForEach `
  {
    $userDN = $_ | Select -expandProperty DistinguishedName
    $user = [adsi]"LDAP://$userDN" #this gets the user to equate to the LDAP equivalent
    If ($user.AllowLogon -eq "0" ) #invokeSet and allowlogon ar eused in conjustion with LDAP because the Attribute is not available with a straight AD query
    {
      $Properties = @{
        Name = "$($_.Name)"
        sAMAccountName = "$($_.sAMAccountName)" #pull the Pre-windows 2000 User ID and Full name of the account
      }
      $custom = New-Object PSObject -property $Properties #pulls the Properties using AD so it can be added to the output
      $out += $custom #add the Name and User ID to the current output matrix to be exported to a CSV file
    }
  }
$out | Select Name,sAMAccountName | Export-Csv -NoTypeInformation "C:\results\TsAllowLogonFalse.csv"