function Get-IPAddress()
{
<#
   .SYNOPSIS
     Finds IP Addresses from a file containing hostnames
   .PARAMETER filename
   .EXAMPLE
     Get-IPAddress -File C:\hostnames.txt > C:\Host-to-IP.txt
#>
  param(
      [Parameter(Mandatory=$true)]
      [string]$File
      )
    $servers = Get-Content $File
    foreach ($server in $servers) {
    $entry = [System.Net.Dns]::GetHostAddresses($server)[0].IPAddressToString
    Write-Output "HostName: $server,IP: $entry"
    }
}
