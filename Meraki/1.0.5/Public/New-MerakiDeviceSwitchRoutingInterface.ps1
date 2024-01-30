function New-MerakiDeviceSwitchRoutingInterface {
    <#
    .SYNOPSIS
    Creates a device switch routing interface.
    
    .DESCRIPTION
    The New-MerakiDeviceSwitchRoutingInterface function allows you to create a device switch routing interface by providing the authentication token, device serial, and a JSON formatted string of routing interface configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER DeviceSerial
    The serial number of the device.
    
    .PARAMETER RoutingInterfaceConfig
    A JSON formatted string of routing interface configuration.
    
    .EXAMPLE
    $RoutingInterfaceConfig = [PSCustomObject]@{
        name = "L3 interface"
        subnet = "192.168.1.0/24"
        interfaceIp = "192.168.1.2"
        multicastRouting = "disabled"
        vlanId = 100
        defaultGateway = "192.168.1.1"
        ospfSettings = @{
            area = "0"
            cost = 1
            isPassiveEnabled = $true
        }
        ospfV3 = @{
            area = "1"
            cost = 2
            isPassiveEnabled = $true
        }
        ipv6 = @{
            assignmentMode = "static"
            prefix = "1:2:3:4::/48"
            address = "1:2:3:4::1"
            gateway = "1:2:3:4::2"
        }
    }

    $RoutingInterfaceConfig = $RoutingInterfaceConfig | ConvertTo-Json
    New-MerakiDeviceSwitchRoutingInterface -AuthToken "your-api-token" -DeviceSerial "Q2GV-ABCD-1234" -RoutingInterfaceConfig $RoutingInterfaceConfig

    This example creates a device switch routing interface with the specified configuration.
    
    .NOTES
    The function requires the "Invoke-RestMethod" cmdlet to be available.
    
    The function returns the response from the API if the creation is successful, otherwise, it displays an error message.
    #>
    
        [CmdletBinding()]
        param (
            [parameter(Mandatory=$true)]
            [string]$AuthToken,
            [parameter(Mandatory=$true)]
            [string]$DeviceSerial,
            [parameter(Mandatory=$true)]
            [string]$RoutingInterfaceConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/devices/$DeviceSerial/switch/routing/interfaces"
    
            $body = $RoutingInterfaceConfig
    
            $response = Invoke-RestMethod -Method Post -Uri $url -Header $header -UserAgent "MerakiPowerShellModule/1.0.2 DocNougat" -Body $body
            return $response
        }
        catch {
            Write-Host $_
        }
    }