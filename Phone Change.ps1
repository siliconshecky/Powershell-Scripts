$csv = Import-CSV "C:\csv\APS Phone change.csv"
ForEach ($user in $csv)
{
     Set-ADUser -Identity $user.name -officephone $user.officephone
}