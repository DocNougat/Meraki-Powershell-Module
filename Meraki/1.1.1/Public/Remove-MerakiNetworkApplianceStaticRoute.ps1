function Remove-MerakiNetworkApplianceStaticRoute {
    <#
    .SYNOPSIS
    Deletes an existing static route for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkApplianceStaticRoute function allows you to delete an existing static route for a specified Meraki network by providing the authentication token, network ID, and static route ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete an existing static route.

    .PARAMETER StaticRouteId
    The ID of the static route you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkApplianceStaticRoute -AuthToken "your-api-token" -NetworkId "your-network-id" -StaticRouteId "your-static-route-id"

    This example deletes the static route with ID "your-static-route-id" for the Meraki network with ID "your-network-id".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the static route deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$StaticRouteId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/staticRoutes/$StaticRouteId"
        $response = Invoke-RestMethod -Method Delete -Uri $uri -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}