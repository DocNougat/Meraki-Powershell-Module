function Get-MerakiAdministeredIdentitiesMeApiKeys {
<#
.SYNOPSIS
Retrieves API keys for the currently authenticated administered identity from the Meraki Dashboard API.

.DESCRIPTION
Get-MerakiAdministeredIdentitiesMeApiKeys sends an HTTP GET request to the Meraki Dashboard endpoint that returns API keys associated with the calling ("me") administered identity. The function supplies the required X-Cisco-Meraki-API-Key header using the provided AuthToken and returns the parsed JSON response as PowerShell objects. Errors encountered during the request are written to debug output and rethrown.

.PARAMETER AuthToken
A mandatory string containing a valid Meraki API key. This token is placed into the X-Cisco-Meraki-API-Key request header and must have sufficient permissions to view API keys for the administered identity.

.EXAMPLE
# Simple usage: display returned API keys
Get-MerakiAdministeredIdentitiesMeApiKeys -AuthToken 'abcd1234efgh5678'

.EXAMPLE
# Capture and inspect individual items
$keys = Get-MerakiAdministeredIdentitiesMeApiKeys -AuthToken $env:MERAKI_API_KEY
foreach ($key in $keys) {
    $key | Format-List
}

.OUTPUTS
System.Object
The function returns deserialized JSON as PowerShell objects (commonly an array of API key entries). Each object contains the fields provided by the Meraki API for administered identity API keys.

.NOTES
- Requires network access to api.meraki.com.
- Ensure the provided API key has appropriate permissions to view administered identity API keys.
- The call uses a custom User-Agent: "MerakiPowerShellModule/1.1.3 DocNougat".
- On failure the function writes debug information and rethrows the original error.

.LINK
https://developer.cisco.com/meraki/api-v1/
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/administered/identities/me/api/keys" -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}