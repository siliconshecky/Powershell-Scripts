<#
.SYNOPSIS
    List all workstations in the domain.  Fields include LastLogonDate and the latest BitLocker password set date (if present)
.DESCRIPTION
    List all workstations in the domain.  Fields include LastLogonDate and the latest BitLocker password set date (if present)
.PARAMETER SearchBase
    OU where the script will begin it's search
.INPUTS
    None
.OUTPUTS
    CSV in script path
.EXAMPLE
    .\New-BitLockerReport.ps1
.NOTES
    Author:             Martin Pugh
    Date:               4/9/2015
      
    Changelog:
        4/9             MLP - Initial Release
        4/15            MLP - Added code to load ActiveDirectory tools, or error out if they aren't present
#>

[CmdletBinding()]
Param (
    [string]$SearchBase = "DC=,DC=,DC=com"
)

Try { Import-Module ActiveDirectory -ErrorAction Stop }
Catch { Write-Warning "Unable to load Active Directory module because $($Error[0])"; Exit }


Write-Verbose "Getting Workstations..." -Verbose
$Computers = Get-ADComputer -Filter * -SearchBase $SearchBase -Properties LastLogonDate,OperatingSystem
$Count = 1
$MissingKey = 0
$Results = ForEach ($Computer in $Computers)
{
    $BitLockerObject = Get-ADObject -Filter {objectclass -eq 'msFVE-RecoveryInformation'} -SearchBase $computer.DistinguishedName -Properties 'msFVE-RecoveryPassword' | Select-Object -Last 1
    Write-Progress -Id 0 -Activity "Searching Computers for BitLocker" -Status "$Count of $($Computers.Count)" -PercentComplete (($Count / $Computers.Count) * 100)
    New-Object PSObject -Property @{
        ComputerName = $Computer.Name
        OS = $Computer.OperatingSystem
        LastLogonDate = $Computer.LastLogonDate 
        BitLockerPasswordSet = Get-ADObject -Filter "objectClass -eq 'msFVE-RecoveryInformation'" -SearchBase $Computer.distinguishedName -Properties msFVE-RecoveryPassword,whenCreated | Sort whenCreated -Descending | Select -First 1 | Select -ExpandProperty whenCreated
        BitLockerRecoveryKey = $BitLockerObject.'msFVE-RecoveryPassword'
    }
     If ($Computer.OperatingSystem -like 'Windows 10 Pro' -and $BitLockerObject.'msFVE-RecoveryPassword' -like '') {$MissingKey ++}
    $Count ++
}
Write-Progress -Id 0 -Activity " " -Status " " -Completed

$ReportPath = "c:\BitlockerRecovery.csv"
Write-Verbose "Building the report..." -Verbose
$Results | Select ComputerName,OS,LastLogonDate,BitLockerPasswordSet,BitLockerRecoveryKey | Sort ComputerName | Export-Csv $ReportPath -NoTypeInformation
Write-Verbose "Report saved at: $ReportPath" -Verbose 
Write-verbose "Number of Windows 10 machines missing bitlocker recovery key is $MissingKey" -Verbose
