function Remove-MerakiNetworkApplianceTrafficShapingCPC {
    <#
    .SYNOPSIS
    Deletes an existing custom performance class for traffic shaping in a Meraki network using the Meraki Dashboard API.

    .DESCRIPTION
    The Remove-MerakiNetworkApplianceTrafficShapingCPC function allows you to delete an existing custom performance class for traffic shaping in a specified Meraki network by providing the authentication token, network ID, and custom performance class ID.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.

    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to delete an existing custom performance class.

    .PARAMETER CustomPerformanceClassId
    The ID of the custom performance class you want to delete.

    .EXAMPLE
    Remove-MerakiNetworkApplianceTrafficShapingCPC -AuthToken "your-api-token" -NetworkId "your-network-id" -CustomPerformanceClassId "your-custom-performance-class-id"

    This example deletes the custom performance class with ID "your-custom-performance-class-id" for traffic shaping in the Meraki network with ID "your-network-id".

    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.

    The function returns the response from the API if the custom performance class deletion is successful, otherwise, it displays an error message.
    #>

    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$CustomPerformanceClassId
    )

    try {
        $header = @{
            "X-Cisco-Meraki-API-Key" = $AuthToken
            "content-type" = "application/json; charset=utf-8"
        }

        $uri = "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/customPerformanceClasses/$CustomPerformanceClassId"
        $response = Invoke-RestMethod -Method Delete -Uri $uri -Header $header
        return $response
    }
    catch {
        Write-Error $_
    }
}