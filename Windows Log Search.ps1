# This script will ask for a Computer Name, feed that name into the Get-Winevent command and output and Audit of Event IDs Validations
# this script will not work in Posershell ISE. Run from normal Powershell only.

Write-host "To select logs from the microsoft folder under Application and Services logs use the following format: Microsoft-Windows-Sysmon/Operational" -foregroundcolor magenta
Write-Host "Output file names do not need an extention, just a name for the csv file." -foregroundcolor magenta
Write-host "Date format should be mm/dd/yyyy. Single digit months do not need a 0 (ie 1 for Jan not 01)" -foregroundcolor magenta
Write-host "To search the current day do not enter an end date. Otherwise make sure there is a day between start and end dates" -foregroundcolor magenta
Write-host "File path is the base, it will append the machine name (if there is one) plus the file name inputted" -foregroundcolor magenta
Write-host "Separate multiple event Ids with a comma"
#get inputs from user
$NameOfLog = Read-Host -Prompt 'What Windows Log are we searching:'
$MachineName = Read-Host -Prompt 'Please enter machine name or blank for local machine' # gets machine name
$DateStart = Read-Host -Prompt 'Date to start from' # date to start reading logs from
$DateEnd = Read-Host -Prompt 'End Date' # date to end reading logs from
$EventID = Read-Host -Prompt 'Event ID'
$EventID = $EventID.Split(',') |  % {iex $_} #seperate multiple IDs into an array
$Filename = Read-Host -Prompt 'Name of output file (csv extention is automatically added)'
$FilePath = Read-Host -Prompt 'File Path'

# Check to make sure the output path exists
$path = "$($FilePath)\$($MachineName)"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}

# Find the Event ID inside the Security Log and Output.For each loops enumerate multiple IDs. If statement checks for an end date and processes everything accordingly
If (!$DateEnd) { Foreach ($ID in $EventID){
Get-WinEvent -ComputerName $MachineName -FilterHashtable @{Logname=$NameOfLog; ID=$EventID;StartTime=$DateStart}| 
    select TimeCreated,ID,Message |
    Export-CSV "$FilePath\$MachineName\$Filename.csv" } } 
Else {
    Foreach ($ID in $EventID){
Get-WinEvent -ComputerName $MachineName -FilterHashtable @{Logname=$NameOfLog; ID=$EventID;StartTime=$DateStart;EndTime=$DateEnd}| 
    select TimeCreated,ID,Message |
    Export-CSV "$FilePath\$MachineName\$Filename.csv" }
}