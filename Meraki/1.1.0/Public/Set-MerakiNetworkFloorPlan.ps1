function Set-MerakiNetworkFloorPlan {
    <#
    .SYNOPSIS
    Updates a floor plan for a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Set-MerakiNetworkFloorPlan function allows you to update a floor plan for a specified Meraki network by providing the authentication token, network ID, floor plan ID, and a floor plan configuration string.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update a floor plan.

    .PARAMETER FloorPlanId
    The ID of the floor plan you want to update.

    .PARAMETER FloorPlanConfig
    A string containing the floor plan configuration. The string should be in JSON format and should include the "imageContents", "name", and at least one of the "bottomLeftCorner", "bottomRightCorner", "center", "topLeftCorner", or "topRightCorner" properties.

    .EXAMPLE
    $image = "C:\path\to\image.png"
    $base64 = Convert-MerakiImageToBase64 -FilePath $image

    $config = [PSCustomObject]@{
        "imageContents" = $base64
        "name" = "Floor Plan 1"
        "bottomLeftCorner" = [PSCustomObject]@{
            "lat" = 37.418095
            "lng" = -122.098531
        }
        "topLeftCorner" = [PSCustomObject]@{
            "lat" = 37.418095
            "lng" = -122.095083
        }
        "topRightCorner" = [PSCustomObject]@{
            "lat" = 37.420352
            "lng" = -122.095083
        }
    } | ConvertTo-Json -Compress

    Set-MerakiNetworkFloorPlan -AuthToken "your-api-token" -NetworkId "L_123456789012345678" -FloorPlanId "1234" -FloorPlanConfig $config

    This example updates the floor plan with ID "1234" for the Meraki network with ID "L_123456789012345678", setting the image contents to a base64-encoded PNG file, the name to "Floor Plan 1", and the corners of the floor plan to the specified latitude and longitude coordinates.

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the floor plan update is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$FloorPlanId,
        [parameter(Mandatory=$true)]
        [string]$FloorPlanConfig
    )
    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $body = $FloorPlanConfig

        $url = "https://api.meraki.com/api/v1/networks/$NetworkId/floorPlans/$FloorPlanId"

        $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat" -Body $body
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}