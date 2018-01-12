# This script will ask for a Computer Name, feed that name into the Get-Winevent command and output and Audit of Event IDs Validations
# this script will not work in Posershell ISE. Run from normal Powershell only.

Write-host "To select logs from the microsoft folder under Application and Services logs use the following format: Microsoft-Windows-Sysmon/Operational" -foregroundcolor magenta
Write-Host "Output file names do not need an extantion, just a name for the csv file." -foregroundcolor magenta
Write-host "Date format should be mm/dd/yyyy. Single digit months do not need a 0 (ie 1 for Jan not 01)" -foregroundcolor magenta
Write-host "Start and end date must be different days (i.e. 1/12/2018 to 1/12/2018 won't work but 1/11/2018 to 1/122018 will)" -foregroundcolor magenta
Write-host "File path is the base, it will append the machine name (if there is one) plus tthe file name inputted" -foregroundcolor magenta

#get inputs from user
$NameOfLog = Read-Host -Prompt 'What Windows Log are we searching:'
$MachineName = Read-Host -Prompt 'Please enter machine name or blank for local machine' # gets machine name
$DateStart = Read-Host -Prompt 'Date to start from' # date to start reading logs from
$DateEnd = Read-Host -Prompt 'End Date' # date to end reading logs from
$EventID = Read-Host -Prompt 'Event ID'
$EventID = $EventID.Split(',')
$Filename = Read-Host -Prompt 'Name of output file (csv extention is automatically added)'
$Path = Read-Host -Prompt 'File Path'

# Check to make sure the output path exists
$path = "C:\Audits\$($MachineName)"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

# Find the Event ID inside the Security Log and Output 
Get-WinEvent -ComputerName $MachineName -FilterHashtable @{Logname=$NameOfLog; ID=$EventID;StartTime=$DateStart;EndTime=$DateEnd}| 
    select TimeCreated,ID,Message |
    Export-CSV "$Path\$MachineName\$Filename.csv"
