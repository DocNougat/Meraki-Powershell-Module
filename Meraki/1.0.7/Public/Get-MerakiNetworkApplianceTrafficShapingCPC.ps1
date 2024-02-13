function Get-MerakiNetworkApplianceTrafficShapingCPC {
    <#
    .SYNOPSIS
    Gets the custom performance class settings for a specific custom performance class configured in a Meraki network's appliance.
    .DESCRIPTION
    This function sends a GET request to the Meraki Dashboard API to retrieve the custom performance class settings for a specific custom performance class configured in a Meraki network's appliance.
    .PARAMETER AuthToken
    The Meraki Dashboard API key.
    .PARAMETER NetworkId
    The ID of the Meraki network whose appliance's custom performance class settings are being retrieved.
    .PARAMETER CustomPerformanceClassId
    The ID of the custom performance class whose settings are being retrieved.
    .EXAMPLE
    Get-MerakiNetworkApplianceTrafficShapingCPC -AuthToken '1234' -NetworkId '5678' -CustomPerformanceClassId '9012'
    Retrieves the custom performance class settings for the custom performance class with ID '9012' in the Meraki network with ID '5678' using the API key '1234'.
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string]$AuthToken,
        [Parameter(Mandatory=$true)]
        [string]$NetworkId,
        [Parameter(Mandatory=$true)]
        [string]$CustomPerformanceClassId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/appliance/trafficShaping/customPerformanceClasses/$CustomPerformanceClassId" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -ErrorAction Stop
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
