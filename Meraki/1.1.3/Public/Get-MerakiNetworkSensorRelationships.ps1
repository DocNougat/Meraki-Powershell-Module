function Get-MerakiNetworkSensorRelationships {
<#
.SYNOPSIS
Retrieves sensor relationship information for a specified Meraki network.

.DESCRIPTION
Get-MerakiNetworkSensorRelationships issues a GET request to the Meraki Dashboard API endpoint
/networks/{networkId}/sensor/relationships and returns the API response as deserialized JSON (PSObject).
This cmdlet requires a valid Cisco Meraki API key and the target network ID.

.PARAMETER AuthToken
The Cisco Meraki API key (X-Cisco-Meraki-API-Key) used to authenticate the request.
Treat this value as a secret; do not hard-code in scripts or store in source control.
You can supply a token obtained from your Meraki dashboard account.

.PARAMETER NetworkId
The identifier (string) of the Meraki network for which sensor relationship data will be retrieved.
Typically looks like "N_XXXXXXXXXXXXXX".

.EXAMPLE
$relationships = Get-MerakiNetworkSensorRelationships -AuthToken $secureApiKey -NetworkId "N_123456789012345"

.LINK
https://developer.cisco.com/meraki/api-v1/ (Meraki Dashboard API reference)
#>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/relationships"

        $response = Invoke-RestMethod -Method Get -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
