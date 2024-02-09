function Remove-MerakiNetworkFloorPlan {
    <#
    .SYNOPSIS
    Deletes a floor plan from a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkFloorPlan function allows you to delete a floor plan from a specified Meraki network by providing the authentication token, network ID, and floor plan ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete the floor plan.

    .PARAMETER FloorPlanId
    The ID of the floor plan you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkFloorPlan -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FloorPlanId "1234"

    This example deletes the floor plan with ID "1234" for the Meraki network with ID "L_123456789012345678".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the floor plan deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FloorPlanId
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
        }

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/floorPlans/$FloorPlanId"

        $response = Invoke-RestMethod -Method Delete -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Host $_
        Throw $_
    }
}