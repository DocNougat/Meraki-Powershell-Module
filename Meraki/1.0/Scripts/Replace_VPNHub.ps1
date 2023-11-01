<#
.SYNOPSIS
Replaces the VPN hub for a Meraki network's site-to-site VPN configuration.

.DESCRIPTION
This script replaces the VPN hub for a Meraki network's site-to-site VPN configuration. It takes in the authentication token, network ID, new hub network ID, and an optional parameter to use the default route. If the VPN configuration mode is "spoke", the script updates the hub ID and default route settings and saves the changes.

.PARAMETER AuthToken
The authentication token for the Meraki dashboard API.

.PARAMETER NetID
The network ID for the Meraki network.

.PARAMETER NewHubNetID
The new hub network ID to replace the existing hub.

.PARAMETER DefaultRoute
An optional boolean parameter to use the default route. Default value is $false.

.EXAMPLE
Replace_VPNHub.ps1 -AuthToken "1234" -NetID "abcd" -NewHubNetID "efgh" -useDefaultRoute $true

This example replaces the VPN hub for the Meraki network with ID "abcd" with the network ID "efgh" and uses the default route.

.NOTES
Author: Alex Heimbuch
Date: 2023-10-19
#>
param(
    [Parameter(Mandatory=$true)]
    [string]$AuthToken,
    [Parameter(Mandatory=$true)]
    [string]$NetworkID,
    [Parameter(Mandatory=$true)]
    [string]$NewHubNetID,
    [Parameter(Mandatory=$false)]
    [bool]$DefaultRoute = $false
)

if($DefaultRoute){
    $useDefaultRoute = "True"
} else {
    $useDefaultRoute = "False"
}

$VPNConfig = Get-MerakiNetworkApplianceVpnSiteToSiteVpn -auth $AuthToken -NetworkId $NetworkID

if($VPNConfig.mode -eq "spoke"){
    $VPNConfig.hubs = [pscustomobject]@{
        hubId = $NewHubNetID
        useDefaultRoute = $useDefaultRoute
    }
    $VPNConfig = $VPNConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceVpnSiteToSiteVpn -AuthToken $AuthToken -NetworkId $NetworkID -VPNConfig $VPNConfig
}