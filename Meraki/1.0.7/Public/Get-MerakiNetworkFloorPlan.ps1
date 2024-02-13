function Get-MerakiNetworkFloorPlan {
    <#
    .SYNOPSIS
        Retrieves a specific floor plan for a Meraki network.

    .PARAMETER AuthToken
        The Meraki API key.

    .PARAMETER NetworkID
        The ID of the Meraki network.

    .PARAMETER FloorplanID
        The ID of the floor plan.

    .EXAMPLE
        Get-MerakiNetworkFloorPlan -AuthToken "YOUR_API_KEY" -NetworkID "YOUR_NETWORK_ID" -FloorplanID "YOUR_FLOORPLAN_ID"

        Retrieves the specified floor plan for the specified network.

    .NOTES
        Requires the Invoke-RestMethod cmdlet.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkID,
        [Parameter(Mandatory=$true)]
        [string]$FloorplanID
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkID/floorPlans/$FloorplanID" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
