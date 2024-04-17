<#
.SYNOPSIS
    This script replaces the VPN hub for all spoke networks in a Meraki organization.

.DESCRIPTION
    This script retrieves all the networks in a Meraki organization and replaces the VPN hub for all spoke networks with a new hub.

.PARAMETER AuthToken
    The Meraki API key used to authenticate the API requests.

.PARAMETER NewHubNetID
    The ID of the new hub network.

.EXAMPLE
    Replace_VPNHub_AllSpokes.ps1 -AuthToken $AuthToken -NewHubNetID "L_725079259"

.NOTES
    Author: Alex Heimbuch
    Last Edit: 2023-10-19
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true)]
    [string]$AuthToken,
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

$Networks = Get-MerakiOrganizationNetworks -auth $AuthToken

ForEach ($Network in $Networks){
    $Network.id
    $VPNConfig = Get-MerakiNetworkApplianceVpnSiteToSiteVpn -auth $AuthToken -NetworkId $Network.id
    If($VPNConfig.mode -eq "spoke"){
        $VPNConfig.hubs = [pscustomobject]@{
            hubId = $NewHubNetID
            useDefaultRoute = $useDefaultRoute
        }
        $VPNConfig = $VPNConfig | ConvertTo-Json -Compress
        Set-MerakiNetworkApplianceVpnSiteToSiteVpn -AuthToken $AuthToken -NetworkId $Network.id -VPNConfig $VPNConfig
    }
}