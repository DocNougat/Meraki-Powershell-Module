function Get-MerakiNetworkApplianceRfProfiles {
<#
.SYNOPSIS
Retrieves RF profiles for a Meraki appliance network.

.DESCRIPTION
Get-MerakiNetworkApplianceRfProfiles queries the Cisco Meraki Dashboard API for RF (radio frequency) profiles associated with the specified network's appliance. The function sends an authenticated GET request to the /networks/{networkId}/appliance/rfProfiles endpoint and returns the deserialized JSON response as PowerShell objects.

.PARAMETER AuthToken
The Cisco Meraki API key to authenticate the request. This should be a valid, active API key with permission to read network appliance settings.

.PARAMETER NetworkId
The identifier of the Meraki network from which to retrieve appliance RF profiles. This is the networkId as shown in the Meraki Dashboard or obtained via the API.

.EXAMPLE
# Basic usage
Get-MerakiNetworkApplianceRfProfiles -AuthToken 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' -NetworkId 'N_123456789012345'

.NOTES
- Requires network access to api.meraki.com.
- Ensure the API key has sufficient permissions for the target network.
- The function will throw a terminating error on HTTP or deserialization failures.

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API documentation)
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/rfProfiles" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
