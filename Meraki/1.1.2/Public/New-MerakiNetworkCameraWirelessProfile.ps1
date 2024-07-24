function New-MerakiNetworkCameraWirelessProfile {
    <#
    .SYNOPSIS
    Creates a new camera wireless profile for a Meraki network.
    
    .DESCRIPTION
    The New-MerakiNetworkCameraWirelessProfile function allows you to create a new camera wireless profile for a specified Meraki network by providing the authentication token, network ID, and a wireless profile configuration string.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the Meraki network for which you want to create a new camera wireless profile.
    
    .PARAMETER WirelessProfileConfig
    A string containing the wireless profile configuration. The string should be in JSON format and should include the properties as defined in the schema.
    
    .EXAMPLE
    $WirelessProfileConfig = [PSCustomObject]@{
        name = "wireless profile A"
        ssid = [PSCustomObject]@{
            name = "ssid test"
            authMode = "8021x-radius"
            encryptionMode = "wpa-eap"
        }
    }

    $WirelessProfileConfig = $WirelessProfileConfig | ConvertTo-Json -Compress

    New-MerakiNetworkCameraWirelessProfile -AuthToken "your-api-token" -NetworkId "N_1234" -WirelessProfileConfig $WirelessProfileConfig

    This example creates a new camera wireless profile for the Meraki network with ID "N_1234".
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$NetworkId,
            [parameter(Mandatory=$true)]
            [string]$WirelessProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/camera/wirelessProfiles"
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.2 DocNougat" -Body $WirelessProfileConfig
            return $response
        }
        catch {
            Write-Debug $_
            Throw $_
        }
    }