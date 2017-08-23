# This script will ask for parameters to look for Event IDs inside of the windows Logs

$machine = read-host -prompt "Machine name"
$id = read-host -prompt "Event ID"
$logname = read-host -prompt "Log Name"
Get-Eventlog -Logname $logname -ComputerName $machine |
Where-Object {$_.EventID -eq $id} |
Format-Table MachineName, Source, EventID -auto