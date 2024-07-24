function Set-MerakiNetworkWirelessSettings {
    <#
    .SYNOPSIS
    Updates a network wireless settings.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessSettings function allows you to update a network wireless settings by providing the authentication token, network ID, and a JSON formatted string of the wireless settings.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER WirelessSettings
    A JSON formatted string of the wireless settings.
    
    .EXAMPLE
    $WirelessSettings = [PSCustomObject]@{
        meshingEnabled = $true
        ipv6BridgeEnabled = $false
        locationAnalyticsEnabled = $false
        upgradeStrategy = "minimizeUpgradeTime"
        ledLightsOn = $false
        namedVlans = @{
            poolDhcpMonitoring = @{
                enabled = $true
                duration = 5
            }
        }
    }
    $WirelessSettings = $WirelessSettings | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessSettings -AuthToken "your-api-token" -NetworkId "1234" -WirelessSettings $WirelessSettings
    
    This example updates a network wireless settings with the specified configuration.
    
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
            [string]$WirelessSettings
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/settings"
    
            $body = $WirelessSettings
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.1 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }