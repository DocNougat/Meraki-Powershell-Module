function Get-MerakiNetworkSwitchQosRules {
<#
.SYNOPSIS
    Gets the QoS rules for a Meraki network switch.
.DESCRIPTION
    This function retrieves the QoS (Quality of Service) rules for a Meraki network switch using the Meraki Dashboard API.
.PARAMETER AuthToken
    The API authentication token for the Meraki Dashboard.
.PARAMETER networkId
    The ID of the Meraki network to retrieve the QoS rules for.
.EXAMPLE
    PS C:\> Get-MerakiNetworkSwitchQosRules -AuthToken "api_token" -networkId "L_123456789"
    Returns the QoS rules for the specified Meraki network switch.
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$networkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$networkId/switch/qosRules" -Header $header
        return $response
    } catch {
        Write-Error "Failed to retrieve QoS rules for network '$networkId'. Error: $_"
    }
}