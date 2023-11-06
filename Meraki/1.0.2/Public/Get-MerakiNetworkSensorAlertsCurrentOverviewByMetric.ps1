function Get-MerakiNetworkSensorAlertsCurrentOverviewByMetric {
    <#
    .SYNOPSIS
    Gets an overview of the current sensor alerts by metric for a specified network.
    
    .DESCRIPTION
    This function retrieves an overview of the current sensor alerts by metric for a specified network in the Meraki dashboard. It requires an API key that has access to the specified network.
    
    .PARAMETER AuthToken
    The Meraki API key used for authentication and authorization.
    
    .PARAMETER NetworkId
    The ID of the network for which to retrieve sensor alerts.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSensorAlertsCurrentOverviewByMetric -AuthToken "12345" -NetworkId "N_12345"
    
    This command retrieves an overview of the current sensor alerts by metric for the network with ID "N_12345" using the API key "12345".
    
    .NOTES
    For more information on the API endpoint used by this function, see the Meraki Dashboard API documentation: https://developer.cisco.com/meraki/api-v1/#!get-network-sensor-alerts-current-overview-by-metric
    #>
    [CmdletBinding()]
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId
    )
    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/current/overview/byMetric" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Failed to retrieve sensor alerts for network '$NetworkId'. Error: $_"
    }
}
