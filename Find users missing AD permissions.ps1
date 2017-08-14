Get-ADUser -SearchBase "OU=,DC=,DC=,DC=com" -Filter * | 
  ?{ $(Get-ACL -Path "AD:$($_.DistinguishedName)" | 
  select -ExpandProperty Access | ?{ $_.IdentityReference -eq "Domain\AD Group" }) -eq $null } | Export-Csv c:\pwresetmissing2.csv