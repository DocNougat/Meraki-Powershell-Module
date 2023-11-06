function Set-MerakiNetworkApplianceSecurityIntrusion {
    <#
    .SYNOPSIS
    Updates the security intrusion settings for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceSecurityIntrusion function allows you to update the security intrusion settings for a specified Meraki network by providing the authentication token, network ID, and a security intrusion configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the security intrusion settings.

    .PARAMETER SecurityIntrusionConfig
    A string containing the security intrusion configuration. The string should be in JSON format and should include the "mode", "idsRulesets", "protectedNetworks", and "useDefault" properties.

    .EXAMPLE
    $config = '{
        "mode": "prevention",
        "idsRulesets": "balanced",
        "protectedNetworks": {
            "useDefault": false,
            "includedCidr": [
                "10.0.0.0/8",
                "127.0.0.0/8",
                "169.254.0.0/16",
                "172.16.0.0/12"
            ],
            "excludedCidr": [
                "10.0.0.0/8",
                "127.0.0.0/8"
            ]
        }
    }'
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceSecurityIntrusion -AuthToken "your-api-token" -NetworkId "your-network-id" -SecurityIntrusionConfig $config

    This example updates the security intrusion settings for the Meraki network with ID "your-network-id", using the specified security intrusion configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the security intrusion settings update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$SecurityIntrusionConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $SecurityIntrusionConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/security/intrusion"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Error $_
    }
}