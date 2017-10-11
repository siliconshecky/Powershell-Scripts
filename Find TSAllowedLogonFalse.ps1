Import-Module ActiveDirectory
$out = @()
$searchOU = "OU=Users,OU=whatever,DC=domain,DC=com"
(Get-ADuser -filter * -searchbase $searchOU -properties DistinguishedName) | ForEach `
  {
    $userDN = $_ | Select -expandProperty DistinguishedName
    $user = [adsi]"LDAP://$userDN"
    If ($user.AllowLogon -eq "0" )
    {
      $Properties = @{
        Name = "$($_.Name)"
        sAMAccountName = "$($_.sAMAccountName)"
      }
      $custom = New-Object PSObject -property $Properties
      $out += $custom
    }
  }
$out | Select Name,sAMAccountName | Export-Csv -NoTypeInformation "C:\results\TsAllowLogonFalse.csv"