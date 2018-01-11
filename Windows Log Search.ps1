# This script will ask for a Computer Name, feed that name into the Get-Winevent command and output and Audit of Event IDs Validations

$NameOfLog = Read-Host -Prompt 'What Windows Log are we searching:'
$MachineName = Read-Host -Prompt 'Please enter machine name or blank for local machine' # gets machine name
$DateStart = Read-Host -Prompt 'Date to start from' # date to start reading logs from
$DateEnd = Read-Host -Prompt 'End Date' # date to end reading logs from
$EventID = Read-Host -Prompt 'Event ID'
$Filename = $DateStart + "to" + $DateEnd
# $Filename -replace ('/','-')
# Check to make sure the output path exists
$path = "C:\Audits\$($MachineName)"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

# Find the Event ID inside the Security Log and Output 
Get-WinEvent -ComputerName $MachineName -FilterHashtable @{Logname=$NameOfLog; ID=$EventID}| 
    select TimeCreated,ID,Message |
    Export-CSV "c:\Audits\$MachineName\${NameOfLog}_$($Filename.replace('/','-')).csv"
