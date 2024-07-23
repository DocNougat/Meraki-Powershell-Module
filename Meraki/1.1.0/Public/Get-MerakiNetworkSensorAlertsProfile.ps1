function Get-MerakiNetworkSensorAlertsProfile {
    <#
    .SYNOPSIS
    Gets information about a sensor alert profile for a Meraki network.
    
    .DESCRIPTION
    This function retrieves information about a specific sensor alert profile for a Meraki network using the Meraki Dashboard API.
    
    .PARAMETER AuthToken
    The Meraki API token used to authenticate the API request.
    
    .PARAMETER NetworkId
    The ID of the Meraki network to get the sensor alert profile from.
    
    .PARAMETER ProfileId
    The ID of the sensor alert profile to retrieve information for.
    
    .EXAMPLE
    PS C:\> Get-MerakiNetworkSensorAlertsProfile -AuthToken "1234" -NetworkId "abcd" -ProfileId "5678"
    
    This example retrieves information about the sensor alert profile with ID "5678" in the Meraki network with ID "abcd" using the Meraki API token "1234".
    
    .NOTES
    For more information about the Meraki Dashboard API, see the official documentation: https://developer.cisco.com/meraki/api-v1/
    #>
    param (
        [parameter(Mandatory=$true)]
        [string]$AuthToken,
        [parameter(Mandatory=$true)]
        [string]$NetworkId,
        [parameter(Mandatory=$true)]
        [string]$ProfileId
    )

    try {
        $header = @{
            'X-Cisco-Meraki-API-Key' = $AuthToken
        }
        $response = Invoke-RestMethod -Method Get -Uri "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/profiles/$ProfileId" -headers $header -UserAgent "MerakiPowerShellModule/1.1.0 DocNougat"
        return $response
    }
    catch {
        Write-Debug $_
        Throw $_
    }
}
