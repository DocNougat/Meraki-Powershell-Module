function Get-MerakiNetworkApplianceRfProfile {
<#
.SYNOPSIS
Retrieves a single RF profile for a Meraki appliance network.

.DESCRIPTION
Get-MerakiNetworkApplianceRfProfile queries the Cisco Meraki Dashboard API for a specific RF (radio frequency) profile associated with the specified network's appliance. The function sends an authenticated GET request to the /networks/{networkId}/appliance/rfProfiles/{rfProfileId} endpoint and returns the deserialized JSON response as a PowerShell object.

.PARAMETER AuthToken
The Cisco Meraki API key to authenticate the request. This should be a valid, active API key with permission to read network appliance settings.

.PARAMETER NetworkId
The identifier of the Meraki network from which to retrieve appliance RF profiles. This is the networkId as shown in the Meraki Dashboard or obtained via the API.

.PARAMETER RfProfileId
The identifier of the RF profile to retrieve. This is the rfProfileId as shown in the Meraki Dashboard or obtained via the API.

.EXAMPLE
# Basic usage
Get-MerakiNetworkApplianceRfProfile -AuthToken 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' -NetworkId 'N_123456789012345' -RfProfileId 'rfProfileId'

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
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$RfProfileId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/rfProfiles/$RfProfileId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
