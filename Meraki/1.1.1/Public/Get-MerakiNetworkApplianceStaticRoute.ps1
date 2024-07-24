function Get-MerakiNetworkApplianceStaticRoute {
    <#
    .SYNOPSIS
    Gets the configuration for a static route in a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve the configuration for a static route in a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance has the static route.
    .PARAMETER StaticRouteId
    The ID of the static route whose configuration is being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceStaticRoute -AuthToken '1234' -NetworkId '5678' -StaticRouteId '9'
    Retrieves the configuration for the static route with ID '9' in the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$StaticRouteId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/staticRoutes/$StaticRouteId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
