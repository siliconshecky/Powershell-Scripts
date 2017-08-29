# This script will read a CSV file of User Logon names and rename the SamAccountName to match the UPN
# You can easily modify the paramters to change any account property. For instance flipping the samaccountanme and userprincipalname you can flip which is being replaced.

$Users = Import-Csv c:\csv\usersfull.csv
Foreach ($user in $users) {
                $upn = (get-aduser $user.samaccountname -properties userprincipalname).userprincipalname
                $upn = ($upn -split “@”)[0]
                    write-host $upn
               set-aduser -identity $user.samaccountname -Replace @{samaccountname=$upn}
               
}
