foreach ( $computer in (Get-Content c:\csv\allwindows.txt) ) {
  Get-WMIObject Win32_UserAccount -Computer $computer -Filter "Disabled = 'true' AND Name = 'Administrator'" `
    | Select-Object __Server, Disabled  | Export-csv c:\csv\localadmindisabled2.csv -append
} 