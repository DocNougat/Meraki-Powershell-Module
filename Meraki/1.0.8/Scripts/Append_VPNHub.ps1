<#
.SYNOPSIS
    This script appends a VPN hub to a spoke VPN configuration in a Meraki network.
.DESCRIPTION
    This script retrieves the VPN configuration for a Meraki network and appends a VPN hub to the configuration if the VPN mode is "spoke". The updated VPN configuration is then saved to the Meraki network.
.PARAMETER AuthToken
    The Meraki API authentication token.
.PARAMETER NetID
    The Meraki network ID.
.PARAMETER NewHubNetID
    The network ID of the new hub to be added to the VPN configuration.
.EXAMPLE
    PS C:\> Append_VPNHub.ps1 -AuthToken $AuthToken -NetID "N_540006725079653222" -NewHubNetID "N_725076564929540006"
.NOTES
    Author: Alex Heimbuch
    Last Edit: 2023-10-19
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
If($VPNConfig.mode -eq "spoke"){
    $VPNConfig.hubs += [pscustomobject]@{
        hubId = $NewHubNetID
        useDefaultRoute = $useDefaultRoute
    }
    $VPNConfig = $VPNConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceVpnSiteToSiteVpn -AuthToken $AuthToken -NetworkId $NetworkID -VPNConfig $VPNConfig
}