function Set-MerakiNetworkAppliancePrefixesDelegatedStatic {
    <#
    .SYNOPSIS
    Updates the configuration of a static delegated prefix using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkAppliancePrefixesDelegatedStatic function allows you to update the configuration of a static delegated prefix by providing the authentication token, network ID, static delegated prefix ID, and a static delegated prefix configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the network for which you want to update the static delegated prefix configuration.

    .PARAMETER StaticDelegatedPrefixId
    The ID of the static delegated prefix for which you want to update the configuration.

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
    Set-MerakiNetworkAppliancePrefixesDelegatedStatic -AuthToken "your-api-token" -NetworkId "your-network-id" -StaticDelegatedPrefixId "your-static-prefix-id" -StaticConfig $config

    This example updates the configuration of the static delegated prefix with ID "your-static-prefix-id" for the network with ID "your-network-id", using the specified static delegated prefix configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticDelegatedPrefixId,
        [parameter(Mandatory=$true)]
        [string]$StaticConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $StaticConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/prefixes/delegated/statics/$StaticDelegatedPrefixId"
        $response = Invoke-RestMethod -Method Put -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}