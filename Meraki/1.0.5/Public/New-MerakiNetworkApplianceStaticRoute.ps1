function New-MerakiNetworkApplianceStaticRoute {
    <#
    .SYNOPSIS
    Creates a new static route for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The New-MerakiNetworkApplianceStaticRoute function allows you to create a new static route for a specified Meraki network by providing the authentication token, network ID, and a static route configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new static route.

    .PARAMETER StaticRouteConfig
    A string containing the static route configuration. The string should be in JSON format and should include the "name", "subnet", and "gatewayIp" properties.

    .EXAMPLE
    $config = [PSCustomObject]@{
        name = "My route"
        subnet = "192.168.1.0/24"
        gatewayIp = "1.2.3.5"
    }

    $config = $config | ConvertTo-Json -Compress
    New-MerakiNetworkApplianceStaticRoute -AuthToken "your-api-token" -NetworkId "your-network-id" -StaticRouteConfig $config

    This example creates a new static route for the Meraki network with ID "your-network-id" using the specified static route configuration.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the static route creation is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticRouteConfig
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $StaticRouteConfig

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/staticRoutes"
        $response = Invoke-RestMethod -Method Post -Uri $uri -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}