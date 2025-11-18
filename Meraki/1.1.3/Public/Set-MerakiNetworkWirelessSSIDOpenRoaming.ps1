function Set-MerakiNetworkWirelessSSIDOpenRoaming {
    <#
    .SYNOPSIS
    Sets the OpenRoaming configuration for a wireless SSID in a Meraki network.

    .DESCRIPTION
    Calls the Meraki Dashboard API to update the openRoaming settings for a specified SSID on a given network. The function sends a PUT request with a JSON body representing the OpenRoaming configuration.

    .PARAMETER AuthToken
    API key for authenticating to the Meraki Dashboard API. Provide a valid X-Cisco-Meraki-API-Key string.

    .PARAMETER NetworkId
    The Meraki network identifier (e.g., "L_123456789012345678"). Identifies the network containing the target SSID.

    .PARAMETER SSIDNumber
    The SSID index number (0-14) identifying which SSID to modify.

    .PARAMETER OpenRoamingConfig
    A JSON string or PowerShell object converted to JSON that contains the openRoaming configuration payload as expected by the Meraki API (e.g., enabled flag, AAA servers, or identity provider settings). Use ConvertTo-Json if passing a PowerShell object.

    .EXAMPLE
    # Build payload as object and convert to JSON
    $payload = @{
        enabled = $true
        tenantId = "12345"
    } | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkWirelessSSIDOpenRoaming -AuthToken $token -NetworkId $netId -SSIDNumber 1 -OpenRoamingConfig $payload

    .NOTES
    Requires network-level write permissions for the API key. API endpoint used: /networks/{networkId}/wireless/ssids/{number}/openRoaming. Ensure the JSON payload matches the Meraki API schema for openRoaming.

    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SSIDNumber,
        [parameter(Mandatory=$true)]
        [string]$OpenRoamingConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ssids/$SSIDNumber/openRoaming"
        
        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $OpenRoamingConfig
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}