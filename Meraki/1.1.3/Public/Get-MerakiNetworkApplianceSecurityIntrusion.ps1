function Get-MerakiNetworkApplianceSecurityIntrusion {
<#
.SYNOPSIS
Retrieves the intrusion settings for a Meraki appliance in the specified network.

.DESCRIPTION
Connects to the Meraki Dashboard API and returns the intrusion configuration for the specified network appliance.
This function uses the provided API key (AuthToken) in the X-Cisco-Meraki-API-Key header and issues a GET request to the
/networks/{networkId}/appliance/security/intrusion endpoint. On success, the JSON response is returned as a PowerShell object.
On failure, the function writes debug information and rethrows the error.

.PARAMETER AuthToken
The Meraki API key used to authenticate the request. This value is sent in the X-Cisco-Meraki-API-Key header.
Type: String
Required: True

.PARAMETER NetworkId
The identifier (ID) of the Meraki network for which to retrieve appliance intrusion settings.
Type: String
Required: True

.EXAMPLE
# Retrieve intrusion settings for a network
$apiKey   = '0123456789abcdef0123456789abcdef01234567'
$network  = 'L_123456789012345678'
Get-MerakiNetworkApplianceSecurityIntrusion -AuthToken $apiKey -NetworkId $network

.NOTES
- The caller must have a valid Meraki API key with sufficient permissions to read appliance settings.
- The function uses Invoke-RestMethod and will throw a terminating error on HTTP or network failures.
- The request is made to: https://api.meraki.com/api/v1/networks/{networkId}/appliance/security/intrusion

.LINK
https://developer.cisco.com/meraki/api-v1/#!get-network-appliance-security-intrusion
#>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/security/intrusion" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}