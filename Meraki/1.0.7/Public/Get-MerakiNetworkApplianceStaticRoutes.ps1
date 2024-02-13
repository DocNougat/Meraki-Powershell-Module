function Get-MerakiNetworkApplianceStaticRoutes {
    <#
    .SYNOPSIS
    Gets the static routes configured in a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve the static routes configured in a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance's static routes are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceStaticRoutes -AuthToken '1234' -NetworkId '5678'
    Retrieves the static routes configured in the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,

        [Parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/staticRoutes" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}