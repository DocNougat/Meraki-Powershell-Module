function Set-MerakiNetworkCameraWirelessProfile {
    <#
    .SYNOPSIS
    Updates the camera wireless profile for a Meraki network.
    
    .DESCRIPTION
    The Set-MerakiNetworkCameraWirelessProfile function allows you to update the camera wireless profile for a specified Meraki network by providing the authentication token, network ID, wireless profile ID, and a wireless profile configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to update the camera wireless profile.
    
    .PARAMETER WirelessProfileId
    The ID of the wireless profile that you want to update.
    
    .PARAMETER WirelessProfileConfig
    A string containing the wireless profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $WirelessProfileConfig = [PSCustomObject]@{
        name = "wireless profile A"
        ssid = [PSCustomObject]@{
            name = "ssid test"
            authMode = "8021x-radius"
        }
    }

    $WirelessProfileConfig = $WirelessProfileConfig | ConvertTo-Json -Compress

    Set-MerakiNetworkCameraWirelessProfile -AuthToken "your-api-token" -NetworkId "N_1234" -WirelessProfileId "3" -WirelessProfileConfig $WirelessProfileConfig

    This example updates the camera wireless profile for the Meraki network with ID "N_1234".
    
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
            [string]$WirelessProfileId,
            [parameter(Mandatory=$true)]
            [string]$WirelessProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/wirelessProfiles/$WirelessProfileId"
    
            $response = Invoke-RestMethod -Method Put -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $WirelessProfileConfig
            return $response
        }
        catch {
            Write-Host $_
        }
    }