function Set-MerakiNetworkApplianceStaticRoute {
    <#
    .SYNOPSIS
    Updates the static route configuration for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkApplianceStaticRoute function allows you to update the static route configuration for a specified Meraki network by providing the authentication token, network ID, static route ID, and a static route configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the static route configuration.

    .PARAMETER StaticRouteId
    The ID of the static route you want to update.

    .PARAMETER StaticRouteConfig
    A string containing the static route configuration. The string should be in JSON format and should include the "gatewayIp", "gatewayVlanId", "name", "subnet", "enabled", "fixedIpAssignments", and "reservedIpRanges" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My route"
        subnet = "192.168.1.0/24"
        fixedIpAssignments = @{
            "22:33:44:55:66:77" = @{
                ip = "1.2.3.4"
                name = "Some client name"
            }
        }
        reservedIpRanges = @(
            @{
                start = "192.168.1.0"
                end = "192.168.1.1"
                comment = "A reserved IP range"
            }
        )
    }
    $config = $config | ConvertTo-Json -Compress
    Set-MerakiNetworkApplianceStaticRoute -AuthToken "your-api-token" -NetworkId "your-network-id" -StaticRouteId "your-static-route-id" -StaticRouteConfig $config

    This example updates the static route configuration for the Meraki network with ID "your-network-id" and static route ID "your-static-route-id", using the specified static route configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the static route configuration update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticRouteId,
        [parameter(Mandatory=$true)]
        [string]$StaticRouteConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $StaticRouteConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/staticRoutes/$StaticRouteId"
        $response = Invoke-RestMethod -Method Put -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}