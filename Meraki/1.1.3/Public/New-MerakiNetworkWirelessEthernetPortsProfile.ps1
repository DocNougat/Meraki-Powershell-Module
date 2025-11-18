function New-MerakiNetworkWirelessEthernetPortsProfile {
    <#
    .SYNOPSIS
    Creates a network wireless Ethernet ports profile.
    
    .DESCRIPTION
    The New-MerakiNetworkWirelessEthernetPortsProfile function allows you to create a network wireless Ethernet ports profile by providing the authentication token, network ID, and a JSON formatted string of the port profile configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER PortProfile
    A JSON formatted string of the port profile configuration.
    
    .EXAMPLE
    $PortProfile = [PSCustomObject]@{
        name = "name"
        ports = @(
            [PSCustomObject]@{
                name = "port"
                enabled = $true
                ssid = 1
                pskGroupId = "2"
            }
        )
        usbPorts = @(
            [PSCustomObject]@{
                name = "usb port"
                enabled = $true
                ssid = 2
            }
        )
    }

    $PortProfile = $PortProfile | ConvertTo-Json
    New-MerakiNetworkWirelessEthernetPortsProfile -AuthToken "your-api-token" -NetworkId "1234" -PortProfile $PortProfile

    This example creates a network wireless Ethernet ports profile with the specified configuration.
    
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
            [string]$PortProfile
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/wireless/ethernet/ports/profiles"
    
            $body = $PortProfile
    
            $response = Invoke-RestMethod -Method Post -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }