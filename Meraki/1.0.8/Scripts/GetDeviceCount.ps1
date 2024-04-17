<#
.SYNOPSIS
    This script retrieves the number of devices in each Meraki network associated with the specified organization.
.DESCRIPTION
    This script uses the Meraki Dashboard API to retrieve the number of devices in each network associated with the specified organization. If a network has no devices, the script outputs the network name and a count of 0.
.PARAMETER AuthToken
    The authorization token for the Meraki Dashboard API.
.EXAMPLE
    PS C:\> Get-DeviceCount -AuthToken $AuthToken
    This example retrieves the number of devices in each network associated with the specified organization.

.NOTES
    Author: Alex Heimbuch
    Last Edit: 2023-10-19
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$AuthToken
)

$Networks = Get-MerakiOrganizationNetworks -AuthToken $AuthToken | Select-Object id, name

ForEach($Network in $Networks) {
    $Devices = Get-MerakiNetworkDevices -AuthToken $AuthToken -NetworkId $Network.ID
    $Count = $Devices.Count
    If($Count = 0){
        Write-Host $Network.name
        Write-Host $Count
    } 
}
