function New-MerakiNetworkAppliancePrefixesDelegatedStatic {
    <#
    .SYNOPSIS
    Creates a new static delegated prefix for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkAppliancePrefixesDelegatedStatic function allows you to create a new static delegated prefix for a specified Meraki network by providing the authentication token, network ID, and a static delegated prefix configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create the static delegated prefix.

    .PARAMETER StaticConfig
    A string containing the static delegated prefix configuration. The string should be in JSON format and should include the "prefix", "origin", "type", "interfaces", and "description" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        prefix = "2001:db8:3c4d:15::/64"
        origin = [PSCustomObject]@{
            type = "internet"
            interfaces = @("wan1")
        }
        description = "Prefix on WAN 1 of Long Island Office network"
    }

    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkAppliancePrefixesDelegatedStatic -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -StaticConfig $config

    This example creates a new static delegated prefix for the Meraki network with ID "L_123456789012345678", using the specified static delegated prefix configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the static delegated prefix creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $StaticConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/prefixes/delegated/statics"
        $response = Invoke-RestMethod -Method Post -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}