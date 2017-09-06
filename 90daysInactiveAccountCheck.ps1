Search-ADAccount -UsersOnly -Search "ou=<OU>,dc=<DC>,dc=<DC>,dc=com" -AccountInactive -TimeSpan "105" |
 Get-ADUser -Properties Name, sAMAccountName, givenName, sn, userAccountControl, lastlogondate | 
 Where {($_.userAccountControl -band 2) -eq $False} | Select Name, sAMAccountName, givenName, sn, lastlogondate | 
 export-csv C:\CSV\90daysinactive.csv
