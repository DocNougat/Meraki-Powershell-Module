function Set-MerakiNetworkWirelessEthernetPortsProfile {
    <#
    .SYNOPSIS
    Updates a network wireless Ethernet ports profile.
    
    .DESCRIPTION
    The Set-MerakiNetworkWirelessEthernetPortsProfile function allows you to update a network wireless Ethernet ports profile by providing the authentication token, network ID, profile ID, and a JSON formatted string of the ports profile configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER ProfileId
    The ID of the profile to be updated.
    
    .PARAMETER PortsProfileConfig
    A JSON formatted string of the ports profile configuration.
    
    .EXAMPLE
    $PortsProfileConfig = [PSCustomObject]@{
        name = "profile1"
        ports = @(
            [PSCustomObject]@{
                ssid = 1
                name = "portName"
                pskGroupId = "123"
                enabled = $true
            }
        )
        usbPorts = @(
            [PSCustomObject]@{
                enabled = $true
                name = "usbport"
                ssid = 2
            }
        )
    }

    $PortsProfileConfig = $PortsProfileConfig | ConvertTo-Json -Compress
    Set-MerakiNetworkWirelessEthernetPortsProfile -AuthToken "your-api-token" -NetworkId "1234" -ProfileId "1001" -PortsProfileConfig $PortsProfileConfig

    This example updates a network wireless Ethernet ports profile with the specified configuration.
    
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
            [string]$ProfileId,
            [parameter(Mandatory=$true)]
            [string]$PortsProfileConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ethernet/ports/profiles/$ProfileId"
    
            $body = $PortsProfileConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.0.8 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }