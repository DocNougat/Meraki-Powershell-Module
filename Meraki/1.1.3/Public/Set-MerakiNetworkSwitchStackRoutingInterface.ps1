function Set-MerakiNetworkSwitchStackRoutingInterface {
    <#
    .SYNOPSIS
    Updates a network switch stack routing interface.
    
    .DESCRIPTION
    The Set-MerakiNetworkSwitchStackRoutingInterface function allows you to update a network switch stack routing interface by providing the authentication token, network ID, switch stack ID, interface ID, and a JSON formatted string of the routing interface configuration.
    
    .PARAMETER AuthToken
    The authentication token (API key) required to access the Meraki Dashboard API.
    
    .PARAMETER NetworkId
    The ID of the network.
    
    .PARAMETER SwitchStackId
    The ID of the switch stack.
    
    .PARAMETER InterfaceId
    The ID of the interface.
    
    .PARAMETER RoutingInterfaceConfig
    A JSON formatted string of the routing interface configuration.
    
    .EXAMPLE
    $RoutingInterfaceConfig = [PSCustomObject]@{
        name = "L3 interface"
        subnet = "192.168.1.0/24"
        interfaceIp = "192.168.1.2"
        multicastRouting = "disabled"
        vlanId = 100
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
            address = "1:2:3:4::1"
            prefix = "1:2:3:4::/48"
            gateway = "1:2:3:4::2"
        }
    }

    $RoutingInterfaceConfig = $RoutingInterfaceConfig | ConvertTo-Json -Compress -Depth 4
    Set-MerakiNetworkSwitchStackRoutingInterface -AuthToken "your-api-token" -NetworkId "1234" -SwitchStackId "5678" -InterfaceId "91011" -RoutingInterfaceConfig $RoutingInterfaceConfig

    This example updates a network switch stack routing interface with the specified configuration.
    
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
            [string]$SwitchStackId,
            [parameter(Mandatory=$true)]
            [string]$InterfaceId,
            [parameter(Mandatory=$true)]
            [string]$RoutingInterfaceConfig
        )
    
        try {
            $header = @{
                "X-Cisco-Meraki-API-Key" = $AuthToken
                "content-type" = "application/json; charset=utf-8"
            }
    
            $url = "https://api.meraki.com/api/v1/networks/$NetworkId/switch/stacks/$SwitchStackId/routing/interfaces/$InterfaceId"
    
            $body = $RoutingInterfaceConfig
    
            $response = Invoke-RestMethod -Method Put -Uri $url -headers $header -UserAgent "MerakiPowerShellModule/1.1.3 DocNougat" -Body $body
            return $response
        }
        catch {
        Write-Debug $_
        Throw $_
    }
    }