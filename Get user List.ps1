# You can change the filter from sAMAccountName to any attribute you like. The more unique the -like part is the more targeted (and fewer) results you will get
# Feel free to add/subtract/change properties selected
	
Get-ADUser -Filter {sAMAccountName -like '*'} -Properties Name, SamAccountName, Description, whenCreated, manager | 
    select-object Name, SamAccountName, Description, whenCreated,@{label="Manager";expression={$_.manager -replace '^CN=|,.*$'}} | 
    export-csv "c:\csv\Contractor List.csv"