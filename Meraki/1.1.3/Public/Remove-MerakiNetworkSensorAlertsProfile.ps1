function Remove-MerakiNetworkSensorAlertsProfile {
    <#
    .SYNOPSIS
    Deletes a sensor alerts profile for a Meraki network.
    
    .DESCRIPTION
    The Remove-MerakiNetworkSensorAlertsProfile function allows you to delete a sensor alerts profile for a specified Meraki network by providing the authentication token, network ID, and profile ID.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The network ID of the Meraki network for which you want to delete the sensor alerts profile.
    
    .PARAMETER ProfileId
    The ID of the sensor alerts profile that you want to delete.
    
    .EXAMPLE
    Remove-MerakiNetworkSensorAlertsProfile -AuthToken "your-api-token" -NetworkId "1234" -ProfileId "5678"
    
    This example deletes the sensor alerts profile with ID "5678" for the Meraki network with ID "1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the deletion is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
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
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/sensor/alerts/profiles/$ProfileId"
    
            $response = Invoke-RestMethod -Method Delete -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat"
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }