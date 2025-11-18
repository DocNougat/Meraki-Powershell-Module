function Set-MerakiNetworkWirelessLocationScanning {
    <#
    .SYNOPSIS
    Updates a network's wireless location scanning settings.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessLocationScanning function allows you to update a network's wireless location scanning settings by providing the authentication token, network ID, and a JSON formatted string of the location scanning settings.

    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
        
    .PARAMETER LocationScanningConfig
    A JSON formatted string of the Location Scanning settings.
    
    .EXAMPLE
    $LocationScanningConfig = [PSCustomObject]@{
        enabled = $true
        api = @{
            enabled = $true
        }
    }

    $LocationScanningConfig = $LocationScanningConfig | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkWirelessLocationScanning -AuthToken "your-api-token" -NetworkId "1234" -LocationScanningConfig $LocationScanningConfig

    This example updates a network wireless RF profile with the specified configuration.
    
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
            [string]$LocationScanningConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/location/scanning"
    
            $body = $LocationScanningConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }