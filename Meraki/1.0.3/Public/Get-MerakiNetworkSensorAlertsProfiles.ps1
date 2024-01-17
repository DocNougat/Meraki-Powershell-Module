function Get-MerakiNetworkSensorAlertsProfiles {
    <#
    .SYNOPSIS
    Retrieves a list of sensor alert profiles for a Meraki network.
    
    .DESCRIPTION
    This function retrieves a list of sensor alert profiles for a Meraki network.
    
    .PARAMETER AuthToken
    The Meraki API token to use for authentication.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which to retrieve sensor alert profiles.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSensorAlertsProfiles -AuthToken "1234" -NetworkId "N_12345"
    
    This example retrieves a list of sensor alert profiles for the Meraki network with ID "N_12345", using the API token "1234".
    
    .NOTES
    For more information about the Meraki API, see https://developer.cisco.com/meraki/api/.
    #>
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
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/profiles" -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat"
        return $response
    }
    catch {
        Write-Error "Error retrieving sensor alert profiles: $_"
    }
}
