function Set-MerakiNetworkSwitchStormControl {
    <#
    .SYNOPSIS
    Updates a network switch storm control.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchStormControl function allows you to update a network switch storm control by providing the authentication token, network ID, and a JSON formatted string of the storm control configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER StormControlConfig
    A JSON formatted string of the storm control configuration.
    
    .EXAMPLE
    $StormControlConfig = [PSCustomObject]@{
        broadcastThreshold = 30
        multicastThreshold = 30
        unknownUnicastThreshold = 30
    }

    $StormControlConfig = $StormControlConfig | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkSwitchStormControl -AuthToken "your-api-token" -NetworkId "1234" -StormControlConfig $StormControlConfig

    This example updates a network switch storm control with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the update is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$StormControlConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stormControl"
    
            $body = $StormControlConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }