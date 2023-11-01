<#
.SYNOPSIS
    This script appends a VPN hub to all spoke VPN configurations in a Meraki organization.

.DESCRIPTION
    This script retrieves all networks in a Meraki organization and appends a VPN hub to all spoke VPN configurations.
    The hub ID and useDefaultRoute values are hard-coded in the script.

.PARAMETER AuthToken
    The Meraki API key used to authenticate the API requests.
.PARAMETER NewHubNetID
    The new hub network ID to be added to all spoke VPN configurations.

.EXAMPLE
    PS C:\> .\Append_VPNHub_AllSpokes.ps1 -AuthToken "2452eb4521568840d65dfdbf6a5cf2fb4271ba9a" -NewHubNetID "N_725079540006656492"

.NOTES
    Author: Alex Heimbuch
    Last Edit: 2023-10-19
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [string]$AuthToken,
    [Parameter(Mandatory = $true)]
    [string]$NewHubNetID,
    [Parameter(Mandatory=$false)]
    [bool]$DefaultRoute = $false
)

# Create C:\Temp if it doesn't exist
if(!(Test-Path "C:\Temp")){
    New-Item -ItemType Directory -Path "C:\Temp"
}

# Generate a fresh name for AppendHub.log every time the script is ran using the date and time
$logFileName = "AppendHub_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log"
$logFilePath = "C:\Temp\$logFileName"

$Networks = Get-MerakiOrganizationNetworks -auth $AuthToken

ForEach ($Network in $Networks){
    $Network.id
    try {
        $VPNConfig = Get-MerakiNetworkApplianceVpnSiteToSiteVpn -AuthToken $AuthToken  -NetworkId $Network.id
        If($VPNConfig.mode -eq "spoke"){
            $VPNConfig.hubs += [pscustomobject]@{
                hubId = $NewHubNetID
                useDefaultRoute = $DefaultRoute
            }
            $VPNConfig = $VPNConfig | ConvertTo-Json -Compress
            Set-MerakiNetworkApplianceVpnSiteToSiteVpn -AuthToken $AuthToken -NetworkId $Network.id -VPNConfig $VPNConfig

            # Logging
            $log = "Network Name: $($Network.name) - Network ID: $($Network.id) - VPN hub appended to spoke VPN configurations"
            Add-Content -Path $logFilePath -Value $log
        } else {
            $log = "Network Name: $($Network.name) - Network ID: $($Network.id) - Network is a Hub, no changes made"
            Add-Content -Path $logFilePath -Value $log
        }
    } catch {
        # Logging
        $log = "Error: $($Error[0].Exception.Message) - Network Name: $($Network.name) - Network ID: $($Network.id)"
        Add-Content -Path $logFilePath -Value $log
    }
}